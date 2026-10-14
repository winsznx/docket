// The site's only script: the mobile menu sheet and the home page ticket.
// Every page works without it.
(() => {
  'use strict';

  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

  setUpMenu();
  setUpHeroTicket();

  // Under 900 px the Menu link opens a full-height sheet. Without this
  // script it jumps to the footer, which lists every page.
  function setUpMenu() {
    const toggle = document.querySelector('[data-menu-open]');
    const sheet = document.getElementById('menu');
    if (!toggle || !sheet || typeof sheet.showModal !== 'function') return;

    toggle.setAttribute('role', 'button');
    toggle.setAttribute('aria-haspopup', 'dialog');
    toggle.setAttribute('aria-expanded', 'false');

    const isMenuEntry = () => history.state && history.state.docketMenu === true;

    const open = () => {
      if (sheet.open) return;
      sheet.showModal();
      toggle.setAttribute('aria-expanded', 'true');
      // The back button closes the sheet instead of leaving the page.
      history.pushState({ docketMenu: true }, '');
    };

    toggle.addEventListener('click', (event) => {
      event.preventDefault();
      open();
    });
    toggle.addEventListener('keydown', (event) => {
      if (event.key === ' ') {
        event.preventDefault();
        open();
      }
    });

    sheet.addEventListener('close', () => {
      toggle.setAttribute('aria-expanded', 'false');
      if (isMenuEntry()) history.back();
      toggle.focus();
    });

    window.addEventListener('popstate', () => {
      if (sheet.open) sheet.close();
    });

    sheet.querySelector('[data-menu-close]').addEventListener('click', () => sheet.close());

    // A click on the backdrop lands on the dialog element itself.
    sheet.addEventListener('click', (event) => {
      if (event.target === sheet) sheet.close();
    });

    // Following a link replaces the history entry the sheet added, so Back
    // from the next page returns here rather than to a copy of this page.
    sheet.addEventListener('click', (event) => {
      const link = event.target.closest('a[href]');
      if (!link || !isMenuEntry()) return;
      if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
      event.preventDefault();
      location.replace(link.href);
    });

    // Tab and Shift+Tab cycle through the sheet's controls and never leave it.
    // Moving focus here rather than leaving it to the browser also reaches
    // the links in Safari, which skips links on Tab by default.
    sheet.addEventListener('keydown', (event) => {
      if (event.key !== 'Tab') return;
      event.preventDefault();
      const focusable = Array.from(sheet.querySelectorAll('a[href], button:not([disabled])'));
      const index = focusable.indexOf(document.activeElement);
      const step = event.shiftKey ? -1 : 1;
      const next = index === -1
        ? (step === 1 ? 0 : focusable.length - 1)
        : (index + step + focusable.length) % focusable.length;
      focusable[next].focus();
    });
  }

  // The home ticket plays its sequence once, pressing Call next before each
  // change, then the visitor steps through it with Call next. With reduced
  // motion nothing plays on its own.
  function setUpHeroTicket() {
    const hero = document.querySelector('[data-hero]');
    if (!hero) return;
    const ticket = hero.querySelector('[data-ticket]');
    const button = hero.querySelector('[data-call-next]');
    const status = hero.querySelector('[data-hero-status]');
    const steps = Array.from(hero.querySelectorAll('[data-step]'));
    if (!ticket || !button || steps.length === 0) return;

    const PRESS_MS = 140;
    const CHANGE_AFTER_PRESS_MS = 260;
    const FIRST_HOLD_MS = 1600;
    const HOLD_MS = 2200;

    let current = 0;
    let countdownTimer = 0;
    let autoplayTimer = 0;

    const pressButton = () => {
      button.classList.add('is-pressed');
      window.setTimeout(() => button.classList.remove('is-pressed'), PRESS_MS);
    };

    const startCountdown = (step) => {
      window.clearInterval(countdownTimer);
      const clock = step.querySelector('[data-countdown]');
      if (!clock) return;
      let remaining = Number(clock.dataset.countdown);
      const render = () => {
        const minutes = Math.floor(remaining / 60);
        const seconds = String(remaining % 60).padStart(2, '0');
        clock.textContent = `${minutes}:${seconds}`;
      };
      render();
      countdownTimer = window.setInterval(() => {
        remaining = Math.max(0, remaining - 1);
        render();
        if (remaining === 0) window.clearInterval(countdownTimer);
      }, 1000);
    };

    const show = (index, { announce }) => {
      current = index;
      steps.forEach((step, i) => step.toggleAttribute('data-active', i === index));
      const step = steps[index];
      ticket.dataset.state = step.dataset.step;
      startCountdown(step);
      if (announce && status) {
        status.textContent = Array.from(step.querySelectorAll('p, li'))
          .map((line) => line.textContent.trim())
          .join(' ');
      }
    };

    const advance = ({ announce }) => {
      pressButton();
      window.setTimeout(
        () => show((current + 1) % steps.length, { announce }),
        CHANGE_AFTER_PRESS_MS,
      );
    };

    button.addEventListener('click', () => {
      window.clearTimeout(autoplayTimer);
      advance({ announce: true });
    });

    hero.classList.add('is-live');

    if (reducedMotion.matches) return;

    const playNext = () => {
      if (current === steps.length - 1) return;
      advance({ announce: false });
      autoplayTimer = window.setTimeout(playNext, HOLD_MS);
    };
    autoplayTimer = window.setTimeout(playNext, FIRST_HOLD_MS);
  }
})();
