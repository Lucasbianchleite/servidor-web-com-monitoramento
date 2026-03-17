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

  window.addEventListener("mousemove", (e) => {
    if (!heroCard) return;
    const x = (window.innerWidth / 2 - e.clientX) / 45;
    const y = (window.innerHeight / 2 - e.clientY) / 45;
    heroCard.style.transform = `translateY(0px) rotateY(${-x}deg) rotateX(${y}deg)`;
  });

  window.addEventListener("mouseleave", () => {
    if (!heroCard) return;
    heroCard.style.transform = "translateY(0px) rotateY(0deg) rotateX(0deg)";
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
});
