/**
 * ═══ CONTACT COMPONENT ═══
 * Renders contact info, social links, and handles form submission.
 */

const Contact = {
  isEmailJsPlaceholder(value) {
    return !value || value === 'YOUR_PUBLIC_KEY' || value === 'PROD_EMAILJS_PUBLIC_KEY';
  },

  init() {
    this.renderContactInfo();
    this.renderExperience();
    this.bindForm();
  },

  /** Populate the contact info sidebar */
  renderContactInfo() {
    const container = document.getElementById('contactInfo');
    if (!container) return;

    const social = CONFIG.social || {};

    // Social icon map using simple emoji/text (no icon library needed)
    const socialIcons = {
      github: '⌘',
      linkedin: '◆',
      twitter: '✦',
      dribbble: '●',
      email: '✉'
    };

    const socialLinks = Object.entries(social)
      .filter(([_, url]) => url)
      .map(([platform, url]) => {
        const href = platform === 'email' ? `mailto:${url}` : url;
        return `<a href="${href}" class="contact__social-item" target="_blank" rel="noopener" title="${platform}">
          ${socialIcons[platform] || '→'}
        </a>`;
      }).join('');

    container.innerHTML = `
      <p class="contact__info-text">
        I'm always open to discussing new projects, creative ideas, or opportunities to be part of your vision.
      </p>
      ${social.email ? `
        <a href="mailto:${social.email}" class="contact__email-link">
          ${social.email}
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18">
            <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
          </svg>
        </a>` : ''}
      <div class="contact__social-list">${socialLinks}</div>
    `;
  },

  /** Render the experience timeline */
  renderExperience() {
    const container = document.getElementById('timeline');
    if (!container || !CONFIG.experience) return;

    container.innerHTML = CONFIG.experience.map((exp, i) => `
      <div class="timeline__item reveal" style="transition-delay: ${i * 0.15}s">
        <div class="timeline__dot"></div>
        <div class="timeline__content">
          <h3 class="timeline__role">${exp.role}</h3>
          <p class="timeline__company">${exp.company}</p>
          <span class="timeline__period">${exp.period}</span>
          <p class="timeline__description">${exp.description}</p>
          <div class="timeline__tech">
            ${exp.tech.map(t => `<span>${t}</span>`).join('')}
          </div>
        </div>
      </div>
    `).join('');
  },

  /** Handle contact form submission */
  bindForm() {
    const form = document.getElementById('contactForm');
    if (!form) return;

    form.addEventListener('submit', async (e) => {
      e.preventDefault();

      const btn = form.querySelector('button[type="submit"]');
      const originalHTML = btn.innerHTML;

      // Check if EmailJS is configured
      if (!CONFIG.emailjs || this.isEmailJsPlaceholder(CONFIG.emailjs.publicKey)) {
        this.showFormStatus(form, 'Please configure EmailJS credentials in config.js', 'error');
        return;
      }

      // Read from FormData to handle typed and auto-filled inputs consistently.
      const formData = new FormData(form);
      const nameValue = String(formData.get('name') || '').trim();
      const emailValue = String(formData.get('email') || '').trim();
      const subjectValue = String(formData.get('subject') || '').trim();
      const messageValue = String(formData.get('message') || '').trim();

      if (!nameValue || !emailValue) {
        this.showFormStatus(form, 'Please enter both your name and email address.', 'error');
        return;
      }

      const templateParams = {
        // Common names used in simple templates
        name: nameValue,
        email: emailValue,
        subject: subjectValue,
        message: messageValue,
        // Common names used in EmailJS examples
        from_name: nameValue,
        from_email: emailValue,
        from_subject: subjectValue,
        reply_to: emailValue,
        // Additional aliases used by some templates/examples
        user_name: nameValue,
        user_email: emailValue,
        sender_name: nameValue,
        sender_email: emailValue,
        fromName: nameValue,
        fromEmail: emailValue
      };

      // Loading state
      btn.disabled = true;
      btn.innerHTML = '<span>Sending...</span>';

      try {
        if (typeof emailjs !== 'undefined') {
          await emailjs.send(
            CONFIG.emailjs.serviceId,
            CONFIG.emailjs.templateId,
            templateParams
          );
        }
        this.showFormStatus(form, '✓ Message sent successfully! I\'ll get back to you soon.', 'success');
        form.reset();
      } catch (error) {
        console.error('Form submission error:', error);
        this.showFormStatus(form, 'Something went wrong. Please try again or email me directly.', 'error');
      } finally {
        btn.disabled = false;
        btn.innerHTML = originalHTML;
      }
    });
  },

  /** Show status message below form */
  showFormStatus(form, message, type) {
    // Remove existing status
    const existing = form.querySelector('.form-status');
    if (existing) existing.remove();

    const status = document.createElement('div');
    status.className = `form-status ${type}`;
    status.textContent = message;
    form.appendChild(status);

    setTimeout(() => status.remove(), 5000);
  }
};
