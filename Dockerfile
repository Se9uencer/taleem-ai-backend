# Use a slim Python base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install OS deps (including ffmpeg)
RUN apt-get update \
 && apt-get install -y --no-install-recommends ffmpeg \
 && rm -rf /var/lib/apt/lists/*

# Install Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your code
COPY . .

# **THIS** is the magic line—must be shell form
CMD sh -c 'uvicorn app:app --host 0.0.0.0 --port $PORT'
