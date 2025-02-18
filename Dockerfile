FROM nvidia/cuda:12.1.1-base-ubuntu22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    build-essential \
    python3.10-dev \
    libgl1 \
    libglib2.0-0 \
    ffmpeg \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install PyTorch
RUN pip install --no-cache-dir torch==2.4.0 torchvision==0.16.0 torchaudio==2.4.0 \
    --index-url https://download.pytorch.org/whl/cu121

# Installation project dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install project
RUN pip install -e .

# Set container startup command
CMD ["sh", "-c", "python ovis/serve/server.py --model_path ${MODEL_PATH:-/model} --port ${PORT:-8000}"]
