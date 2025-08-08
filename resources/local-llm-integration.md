# Local LLM Integration for Neovim and GitLab

This document provides comprehensive research and next steps for running local Large Language Models (LLMs) that integrate with Neovim and GitLab, specifically on NixOS systems using flakes.

## Overview

Local LLM integration provides several advantages over cloud-based solutions:
- **Privacy**: Code and data never leave your infrastructure
- **Cost**: No API fees after initial setup
- **Customization**: Fine-tune models for specific codebases
- **Reliability**: No dependency on external services
- **Speed**: Reduced latency for local inference

## Recommended Local LLM Solutions

### 1. Ollama (Recommended for Ease of Use)

**Repository**: https://github.com/ollama/ollama  
**NixOS Package**: `pkgs.ollama`

Ollama is the easiest way to run local LLMs with minimal setup.

**Pros**:
- Simple installation and management
- Automatic model downloading and management
- REST API compatible with OpenAI
- Supports many popular models (Code Llama, Llama 2, Mistral, etc.)
- Good performance optimization

**Cons**:
- Less customization than other solutions
- Limited fine-tuning capabilities

**Installation on NixOS**:
```nix
# In your system configuration
environment.systemPackages = with pkgs; [
  ollama
];

# Enable the service
services.ollama = {
  enable = true;
  acceleration = "cuda"; # or "rocm" for AMD GPUs
};
```

**Recommended Models for Code**:
- `codellama:13b` - Meta's Code Llama, excellent for code generation
- `deepseek-coder:6.7b` - Specialized coding model, good balance of size/performance
- `phind-codellama:34b` - Enhanced Code Llama for coding tasks (requires more RAM)

### 2. Llamafile (Self-Contained Option)

**Repository**: https://github.com/Mozilla-Ocho/llamafile  
**NixOS Package**: Available as `pkgs.llamafile`

Single-file executables that contain both the model and runtime.

**Pros**:
- Completely self-contained
- No installation required
- Cross-platform compatibility
- Mozilla backing for reliability

**Cons**:
- Limited model selection
- Larger file sizes
- Less ecosystem integration

### 3. Text Generation WebUI (Advanced Option)

**Repository**: https://github.com/oobabooga/text-generation-webui  
**NixOS Installation**: Via Python packages or container

Full-featured web interface for running various LLM architectures.

**Pros**:
- Supports most model architectures
- Advanced fine-tuning capabilities
- Comprehensive API
- Active community

**Cons**:
- More complex setup
- Higher resource requirements
- Requires more maintenance

## GPU Acceleration on NixOS

### NVIDIA GPUs
```nix
# In your NixOS configuration
services.xserver.videoDrivers = [ "nvidia" ];
hardware.opengl = {
  enable = true;
  driSupport = true;
  driSupport32Bit = true;
};

hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;
};

# Enable CUDA support
nixpkgs.config.allowUnfree = true;
environment.systemPackages = with pkgs; [
  cudatoolkit
  cudnn
];
```

### AMD GPUs (ROCm)
```nix
# In your NixOS configuration
hardware.opengl = {
  enable = true;
  extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
};

systemd.tmpfiles.rules = [
  "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocm-runtime}"
];
```

## Neovim Integration Options

### 1. wtf.nvim Integration

The wtf.nvim plugin can be configured to use local LLMs instead of cloud APIs:

```lua
require('wtf').setup({
  -- Use local Ollama instance
  openai_api_key = "not-needed-for-local",
  openai_model_id = "codellama:13b",
  openai_api_base = "http://localhost:11434/v1",
  
  -- Alternative: Use text-generation-webui
  -- openai_api_base = "http://localhost:5000/v1",
})
```

### 2. ChatGPT.nvim with Local Backend

**Repository**: https://github.com/jackMort/ChatGPT.nvim

Can be configured to use local OpenAI-compatible APIs:

```lua
require("chatgpt").setup({
  api_host_cmd = "echo http://localhost:11434",
  api_key_cmd = "echo sk-no-key-required",
})
```

### 3. CodeCompanion.nvim

**Repository**: https://github.com/olimorris/codecompanion.nvim

Modern Neovim AI plugin with local LLM support:

```lua
require("codecompanion").setup({
  adapters = {
    ollama = function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url = "http://localhost:11434/v1",
          api_key = "not-required",
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "ollama",
    },
    inline = {
      adapter = "ollama", 
    },
  },
})
```

## GitLab Integration

### 1. GitLab AI Features

GitLab offers several AI integration points:

- **Code Suggestions**: Real-time code completion
- **Merge Request Summaries**: Automated MR descriptions
- **Issue Summarization**: Auto-generated issue summaries
- **Security Scanning**: AI-enhanced vulnerability detection

### 2. Self-Hosted GitLab with Local LLM

For self-hosted GitLab instances, you can integrate local LLMs via:

**API Proxies**: Create a proxy service that translates GitLab AI requests to your local LLM API.

```nix
# Example systemd service for LLM proxy
systemd.services.gitlab-llm-proxy = {
  enable = true;
  description = "GitLab LLM Proxy Service";
  wantedBy = [ "multi-user.target" ];
  after = [ "network.target" "ollama.service" ];
  
  serviceConfig = {
    Type = "simple";
    User = "gitlab-llm-proxy";
    Group = "gitlab-llm-proxy";
    ExecStart = "${pkgs.python3}/bin/python /path/to/gitlab-llm-proxy.py";
    Restart = "always";
    RestartSec = 10;
  };
};
```

**GitLab CI/CD Integration**: Use local LLMs in CI/CD pipelines for:
- Code review automation
- Documentation generation
- Test case generation
- Security analysis

### 3. Custom GitLab Webhooks

Create webhook handlers that:
- Analyze merge requests with local LLMs
- Generate automated code reviews
- Suggest improvements and optimizations
- Check code quality and style

## Performance Considerations

### Hardware Requirements

**Minimum Setup**:
- 16GB RAM
- Modern CPU (8+ cores recommended)
- Optional: GPU with 8GB+ VRAM

**Recommended Setup**:
- 32GB+ RAM
- High-core-count CPU (16+ cores)
- NVIDIA RTX 4090 or similar (24GB VRAM)
- Fast NVMe storage

### Model Size Recommendations

| Use Case | Model Size | RAM Required | Performance |
|----------|------------|--------------|-------------|
| Code completion | 7B | 8GB | Fast |
| Code explanation | 13B | 16GB | Good |
| Complex reasoning | 34B+ | 32GB+ | Excellent |

## Security Considerations

1. **Network Isolation**: Run LLMs on isolated networks
2. **Access Controls**: Implement proper authentication
3. **Data Sanitization**: Remove sensitive data from prompts
4. **Audit Logging**: Log all LLM interactions
5. **Regular Updates**: Keep models and software updated

## Cost Analysis

### Initial Setup Costs
- Hardware: $2,000-$10,000 (depending on requirements)
- Time investment: 1-2 weeks setup and configuration

### Ongoing Costs
- Electricity: $50-200/month (depending on usage)
- Maintenance: Minimal (automated with Nix)

### ROI Comparison
- Cloud APIs: $20-100+/month per developer
- Local setup: Break-even in 3-12 months

## Implementation Roadmap

### Phase 1: Basic Setup (Week 1)
1. Install Ollama on NixOS server
2. Download and test Code Llama model
3. Configure wtf.nvim for local LLM
4. Test basic code explanation features

### Phase 2: Enhanced Integration (Week 2)
1. Set up ChatGPT.nvim with local backend
2. Configure GitLab webhook for MR analysis
3. Implement basic CI/CD integration
4. Performance optimization and monitoring

### Phase 3: Advanced Features (Week 3-4)
1. Fine-tune models on specific codebase
2. Implement advanced GitLab integrations
3. Set up monitoring and alerting
4. Documentation and team training

## Next Steps

1. **Hardware Assessment**: Evaluate current server capabilities
2. **Model Selection**: Choose appropriate models for use cases
3. **NixOS Configuration**: Implement the flake-based setup
4. **Testing Phase**: Start with wtf.nvim integration
5. **Gradual Rollout**: Expand to team after successful testing

## Example NixOS Flake Configuration

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.llm-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          # Ollama service
          services.ollama = {
            enable = true;
            acceleration = "cuda";
            environmentVariables = {
              OLLAMA_ORIGINS = "*";
              OLLAMA_HOST = "0.0.0.0:11434";
            };
          };

          # Open firewall for Ollama
          networking.firewall.allowedTCPPorts = [ 11434 ];

          # GPU support
          hardware.opengl.enable = true;
          services.xserver.videoDrivers = [ "nvidia" ];

          # System packages
          environment.systemPackages = with pkgs; [
            ollama
            curl
            htop
            nvtop
          ];
        }
      ];
    };
  };
}
```

This comprehensive setup provides a solid foundation for local LLM integration with Neovim and GitLab while maintaining the benefits of NixOS's declarative configuration management.