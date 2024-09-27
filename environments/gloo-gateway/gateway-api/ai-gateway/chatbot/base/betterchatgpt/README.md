# betterchatgpt github:
https://github.com/ztjhz/BetterChatGPT

## docker build command
```
git clone https://github.com/ztjhz/BetterChatGPT.git

cd BetterChatGPT   

docker buildx create --use --name ly-builder

docker buildx inspect ly-builder --bootstrap

docker buildx build --platform linux/amd64,linux/arm64 -t ably77/betterchatgpt:0.1 --push .
```