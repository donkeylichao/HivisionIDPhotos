FROM python:3.10-slim

# Install system dependencies
RUN sed -i 's|http://deb.debian.org|https://mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt requirements-app.txt ./

RUN pip install --no-cache-dir -r requirements.txt -r requirements-app.txt

COPY scripts/download_model.py scripts/download_model.py

RUN python scripts/download_model.py --models all \
    && test -s hivision/creator/weights/hivision_modnet.onnx \
    && test -s hivision/creator/weights/modnet_photographic_portrait_matting.onnx \
    && test -s hivision/creator/weights/rmbg-1.4.onnx \
    && test -s hivision/creator/weights/birefnet-v1-lite.onnx \
    && test -s hivision/creator/retinaface/weights/retinaface-resnet50.onnx

COPY . .

EXPOSE 7860
EXPOSE 8080

CMD ["python3", "-u", "app.py", "--host", "0.0.0.0", "--port", "7860"]
