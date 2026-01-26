# NGF Agentic Reference Stack

A reference implementation showcasing NGINX Gateway Fabric as a multi-layer gateway for AI agent applications.

## Architecture

This project demonstrates NGF serving three critical gateway roles:

1. **Reverse Proxy** - Routes traffic to the AI chatbot frontend
2. **API Gateway** - Manages frontend-to-backend chat completion requests
3. **LLM Inference Gateway** - Routes backend requests to vLLM inference API via Gateway API inference extension
```
User → NGF (Reverse Proxy) → Frontend App
                ↓
         NGF (API Gateway) → Backend API
                ↓
    NGF (Inference Gateway) → vLLM Inference API
```

## Components

- **Frontend**: AI chatbot interface
- **Backend**: Chat completion API service
- **Inference**: vLLM model serving
- **Gateway**: NGINX Gateway Fabric (all layers)

## Quick Start
```bash
# Deploy the stack
kubectl apply -f manifests/

# Access the chatbot
kubectl port-forward svc/chatbot-frontend 8080:80
```

Open http://localhost:8080

## Prerequisites

- Kubernetes cluster
- NGINX Gateway Fabric installed
- Gateway API CRDs

## Learn More

- [NGINX Gateway Fabric](https://github.com/nginxinc/nginx-gateway-fabric)
- [Gateway API](https://gateway-api.sigs.k8s.io/)
- [vLLM](https://github.com/vllm-project/vllm)


## Todo

- [ ] Gateway inference extension, perhaps with dummy VLLM endpoint. https://github.com/llm-d/llm-d-inference-sim/tree/main and https://docs.nginx.com/nginx-gateway-fabric/how-to/gateway-api-inference-extension/
- [ ] JWT validation