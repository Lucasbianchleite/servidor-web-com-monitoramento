document.addEventListener("DOMContentLoaded", () => {
  const navLinks = document.querySelectorAll(".nav-links a");
  const sections = document.querySelectorAll("section[id]");
  const revealElements = document.querySelectorAll(
    ".hero, .stat, .card, .timeline-item, .chip, .cta-box, .hero-card, .overview-box, .overview-item"
  );

  navLinks.forEach(link => {
    link.addEventListener("click", (e) => {
      const href = link.getAttribute("href");
      if (href && href.startsWith("#")) {
        e.preventDefault();
        const target = document.querySelector(href);
        if (target) {
          target.scrollIntoView({ behavior: "smooth", block: "start" });
        }
      }
    });
  });

  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add("show");
      }
    });
  }, { threshold: 0.15 });

  revealElements.forEach(el => {
    el.classList.add("hidden-reveal");
    revealObserver.observe(el);
  });

  const sectionObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const currentId = entry.target.getAttribute("id");
        navLinks.forEach(link => {
          link.classList.remove("active-link");
          if (link.getAttribute("href") === `#${currentId}`) {
            link.classList.add("active-link");
          }
        });
      }
    });
  }, { threshold: 0.45 });

  sections.forEach(section => sectionObserver.observe(section));

  const statsContainer = document.querySelector(".stats");

  const animateCounter = (element, endValue, suffix = "", duration = 1200) => {
    let startTime = null;

    const step = (timestamp) => {
      if (!startTime) startTime = timestamp;
      const progress = Math.min((timestamp - startTime) / duration, 1);
      const current = Math.floor(progress * endValue);
      element.textContent = current + suffix;

      if (progress < 1) {
        requestAnimationFrame(step);
      } else {
        element.textContent = endValue + suffix;
      }
    };

    requestAnimationFrame(step);
  };

  const statsObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;

      const statNumbers = entry.target.querySelectorAll("h3");
      statNumbers.forEach(stat => {
        if (stat.dataset.animated === "true") return;

        const originalText = stat.textContent.trim();

        if (originalText === "24/7") {
          animateCounter(stat, 24, "/7");
        } else if (originalText === "1 min") {
          animateCounter(stat, 1, " min", 700);
        } else if (originalText === "3+") {
          animateCounter(stat, 3, "+", 900);
        } else if (originalText.toLowerCase() === "logs") {
          stat.textContent = "Logs";
        }

        stat.dataset.animated = "true";
      });

      observer.unobserve(entry.target);
    });
  }, { threshold: 0.4 });

  if (statsContainer) {
    statsObserver.observe(statsContainer);
  }

  const heroCard = document.querySelector(".hero-card");
  const isDesktop = window.matchMedia("(min-width: 981px)");

  const handleMouseMove = (e) => {
    if (!heroCard || !isDesktop.matches) return;
    const x = (window.innerWidth / 2 - e.clientX) / 45;
    const y = (window.innerHeight / 2 - e.clientY) / 45;
    heroCard.style.transform = `translateY(0px) rotateY(${-x}deg) rotateX(${y}deg)`;
  };

  const resetHeroCard = () => {
    if (!heroCard) return;
    heroCard.style.transform = "translateY(0px) rotateY(0deg) rotateX(0deg)";
  };

  window.addEventListener("mousemove", handleMouseMove);
  window.addEventListener("mouseleave", resetHeroCard);
  window.addEventListener("resize", () => {
    if (!isDesktop.matches) {
      resetHeroCard();
    }
  });

  const typingText = document.querySelector(".typing-text");
  const commands = [
    "curl -I http://localhost",
    "status: online",
    "webhook dispatched successfully",
    "watching service health..."
  ];

  if (typingText) {
    let commandIndex = 0;
    let charIndex = 0;
    let deleting = false;

    const typeLoop = () => {
      const current = commands[commandIndex];

      if (!deleting) {
        typingText.textContent = current.slice(0, charIndex + 1);
        charIndex++;

        if (charIndex === current.length) {
          deleting = true;
          setTimeout(typeLoop, 1300);
          return;
        }
      } else {
        typingText.textContent = current.slice(0, charIndex - 1);
        charIndex--;

        if (charIndex === 0) {
          deleting = false;
          commandIndex = (commandIndex + 1) % commands.length;
        }
      }

      setTimeout(typeLoop, deleting ? 35 : 70);
    };

    typeLoop();
  }

  const matrixCanvases = [
    document.getElementById("matrixLeft"),
    document.getElementById("matrixRight")
  ];

  const initMatrix = (canvas, side = "left") => {
    if (!canvas) return null;

    const ctx = canvas.getContext("2d");
    let width = 0;
    let height = 0;
    let fontSize = 18;
    let columns = 0;
    let drops = [];
    let chars = [];
    let animationId = null;

    const charset = [
      "0", "1", "{", "}", "[", "]", "<", ">", "/", "\\", "$", "#", "@", "=", "+",
      "L", "N", "X", "S", "H", "C", "R", "T", "P", "U", "G", "I", "M", "D"
    ];

    const resize = () => {
      const rect = canvas.getBoundingClientRect();
      width = Math.max(1, Math.floor(rect.width));
      height = window.innerHeight;

      const dpr = window.devicePixelRatio || 1;
      canvas.width = width * dpr;
      canvas.height = height * dpr;
      canvas.style.height = `${height}px`;

      ctx.setTransform(1, 0, 0, 1, 0, 0);
      ctx.scale(dpr, dpr);

      fontSize = width < 130 ? 14 : 18;
      columns = Math.max(6, Math.floor(width / fontSize));
      drops = Array.from({ length: columns }, () => Math.floor(Math.random() * -28));
      chars = charset;
    };

    const draw = () => {
      ctx.fillStyle = "rgba(2, 6, 23, 0.085)";
      ctx.fillRect(0, 0, width, height);

      ctx.font = `600 ${fontSize}px Consolas, Monaco, monospace`;
      ctx.textAlign = "center";

      for (let i = 0; i < drops.length; i++) {
        const char = chars[Math.floor(Math.random() * chars.length)];
        const x = i * fontSize + fontSize / 2;
        const y = drops[i] * fontSize;

        const glowAlpha = side === "left" ? 0.9 : 0.75;
        const bodyAlpha = side === "left" ? 0.65 : 0.55;

        ctx.shadowBlur = 18;
        ctx.shadowColor = "rgba(56, 189, 248, 0.6)";
        ctx.fillStyle = `rgba(125, 211, 252, ${glowAlpha})`;
        ctx.fillText(char, x, y);

        ctx.shadowBlur = 6;
        ctx.shadowColor = "rgba(14, 165, 233, 0.45)";
        ctx.fillStyle = `rgba(56, 189, 248, ${bodyAlpha})`;
        ctx.fillText(char, x, y + 1);

        ctx.shadowBlur = 0;

        if (y > height && Math.random() > 0.975) {
          drops[i] = 0;
        }

        drops[i]++;
      }

      animationId = requestAnimationFrame(draw);
    };

    resize();
    draw();

    return {
      resize,
      destroy: () => {
        if (animationId) cancelAnimationFrame(animationId);
      }
    };
  };

  let matrixInstances = [];

  const setupMatrix = () => {
    matrixInstances.forEach(instance => instance?.destroy());
    matrixInstances = [];

    if (window.innerWidth <= 1180) return;

    matrixInstances = [
      initMatrix(matrixCanvases[0], "left"),
      initMatrix(matrixCanvases[1], "right")
    ];
  };

  setupMatrix();

  let resizeTimeout;
  window.addEventListener("resize", () => {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(() => {
      setupMatrix();
    }, 120);
  });
});
