/**
 * ╔══════════════════════════════════════════════════════════════╗
 * ║              PORTFOLIO CONFIGURATION FILE                    ║
 * ║                                                              ║
 * ║  Edit this file to personalize your entire portfolio.        ║
 * ║  No need to touch HTML, CSS, or JS — everything is          ║
 * ║  driven from this single config.                             ║
 * ╚══════════════════════════════════════════════════════════════╝
 */

const CONFIG = {

  // ─── Personal Info ───────────────────────────────────────────
  name: "Ruthran Raghavan",
  title: "Chief AI Scientist",
  tagline: "Designing and deploying enterprise-grade AI systems that deliver measurable ROI.",
  roles: ["Chief AI Scientist", "AI Automation Expert", "Multi-Agent Orchestrator", "Corporate Trainer"],

  about: {
    description: [
      "I'm a Chief AI Scientist with 10+ years of experience designing, developing, and deploying enterprise-grade AI systems, specializing in LLM-powered applications and multi-agent orchestration.",
      "Expert in building advanced RAG pipelines and complex automation workflows using LangChain and LangGraph to bridge the gap between cutting-edge AI research and real-world scalability.",
      "A leading corporate trainer who has delivered 10,000+ hours of AI training to over 5,000 learners worldwide, enabling organizations to achieve 10x productivity improvements."
    ],
    resumeUrl: "docs/resume.pdf",
    avatarUrl: "assets/images/profile.jpeg"  // Leave empty to use generated initials avatar
  },

  // ─── Social Links ───────────────────────────────────────────
  social: {
    github: "https://github.com/hereandnowai",
    linkedin: "https://linkedin.com/in/ruthranraghavan",
    twitter: "https://twitter.com/hereandnowai",
    email: "ruthran@hereandnow.co.in"
  },

  // ─── Skills ─────────────────────────────────────────────────
  skills: [
    { name: "LLMs / GenAI (GPT-5, Gemini)", level: 98, icon: "🤖" },
    { name: "LangChain / LangGraph",       level: 95, icon: "🦜" },
    { name: "Python / AI-ML Stack",       level: 95, icon: "🐍" },
    { name: "Multi-Agent Systems",        level: 92, icon: "🤝" },
    { name: "PyTorch / TensorFlow",       level: 90, icon: "🔥" },
    { name: "RAG / Elasticsearch",        level: 90, icon: "📚" },
    { name: "MCP Servers / Automation",   level: 88, icon: "⚙️" },
    { name: "Docker / Kubernetes / Azure",level: 85, icon: "🐳" },
  ],

  // ─── Projects ───────────────────────────────────────────────
  projects: [
    {
      title: "Probot AI Professor",
      description: "A multimodal AI professor capable of natural conversation, adaptive curriculum delivery, and speech synthesis for personalized learning.",
      tech: ["Generative AI", "Speech Synthesis", "LLMs", "Python"],
      liveUrl: "#",
      githubUrl: "#",
      image: "",
      featured: true,
      category: "ai"
    },
    {
      title: "Enterprise Multi-Agent Orchestrator",
      description: "A complex multi-agent system built with LangGraph for autonomous enterprise operations, streamlining high-complexity workflows.",
      tech: ["LangGraph", "LangChain", "OpenAI", "Python"],
      liveUrl: "#",
      githubUrl: "#",
      image: "",
      featured: true,
      category: "automation"
    },
    {
      title: "Advanced RAG Pipelines",
      description: "Large-scale Retrieval-Augmented Generation systems integrated with Elasticsearch and Haystack, boosting search accuracy by over 40%.",
      tech: ["Elasticsearch", "Haystack", "RAG", "LLMs"],
      liveUrl: "#",
      githubUrl: "#",
      image: "",
      featured: true,
      category: "ai"
    },
    {
      title: "MCP Automation Infrastructure",
      description: "Developed robust Model Context Protocol (MCP) servers and clients for seamless communication between AI agents and external tools.",
      tech: ["MCP", "TypeScript", "Node.js", "AI Agents"],
      liveUrl: "#",
      githubUrl: "#",
      image: "",
      featured: false,
      category: "automation"
    },
    {
      title: "Predictive Maintenance AI",
      description: "Predictive maintenance agents for industrial deployments that increased equipment uptime by 20% using real-time sensor data.",
      tech: ["Python", "TensorFlow", "IoT", "Scikit-Learn"],
      liveUrl: "#",
      githubUrl: "#",
      image: "",
      featured: false,
      category: "industrial"
    },
    {
      title: "AI Language Assessment Engine",
      description: "An NLP-powered language evaluation system using CNNs and RNNs, improving assessment accuracy by 30% over manual methods.",
      tech: ["NLP", "CNNs", "RNNs", "Python"],
      liveUrl: "#",
      githubUrl: "#",
      image: "",
      featured: false,
      category: "ai"
    }
  ],

  // ─── Experience / Timeline ──────────────────────────────────
  experience: [
    {
      role: "Chief AI Scientist",
      company: "Here And Now AI",
      period: "2018 — Present",
      description: "Leading the development of enterprise-grade AI automation frameworks and multi-agent systems. Delivered 180+ AI agents across finance, healthcare, and manufacturing sectors.",
      tech: ["LangGraph", "LangChain", "OpenAI", "Python", "Azure"]
    },
    {
      role: "Data Scientist",
      company: "HERE AND NOW – The Language Institute",
      period: "2011 — 2023",
      description: "Architected predictive modeling systems for personalized education. Built AI-powered language assessment engines reducing manual processing time by 40%.",
      tech: ["Python", "TensorFlow", "Scikit-Learn", "SVM", "NLP"]
    },
    {
      role: "M.Sc. Statistics & Psychology",
      company: "Madras University",
      period: "2010 — 2012",
      description: "Specialized in advanced research and modeling, bridging cognitive neuroscience with AI architecture for human-like interaction design.",
      tech: ["Statistical Modeling", "Cognitive Science", "Predictive Analytics"]
    }
  ],

  // ─── Theme Configuration ────────────────────────────────────
  theme: {
    // Primary accent color (buttons, links, highlights)
    primaryColor: "#6366F1",
    // Secondary accent for gradients
    secondaryColor: "#8B5CF6",
    // Accent for special highlights
    accentColor: "#EC4899",
    // Background colors
    bgPrimary: "#0B0D17",
    bgSecondary: "#111427",
    bgCard: "rgba(17, 20, 39, 0.7)",
    // Text colors
    textPrimary: "#E2E8F0",
    textSecondary: "#94A3B8",
    textMuted: "#475569",
    // Glass effect
    glassBg: "rgba(255, 255, 255, 0.03)",
    glassBorder: "rgba(255, 255, 255, 0.08)",
    // Border radius
    borderRadius: "16px",
    // Font
    fontFamily: "'Inter', sans-serif"
  },

  // ─── EmailJS (for contact form) ─────────────────────────────
  emailjs: {
    publicKey: "PROD_EMAILJS_PUBLIC_KEY",
    serviceId: "PROD_EMAILJS_SERVICE_ID",
    templateId: "PROD_EMAILJS_TEMPLATE_ID"
  },

  // ─── Advanced Settings ──────────────────────────────────────
  settings: {
    enableParticles: true,
    enableCursorGlow: true,
    enableSmoothScroll: true,
    enablePreloader: true,
    enableSoundEffects: false,
    particleCount: 50,
    animationSpeed: 1,    // 0.5 = slow, 1 = normal, 2 = fast
  }
};

