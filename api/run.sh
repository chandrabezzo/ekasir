#!/bin/bash

# e-Kasir API Server Launcher

echo "🚀 Starting e-Kasir API Server..."
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from .env.example..."
    cp .env.example .env
    echo "✅ .env file created. Please update it with your configuration."
fi

# Install dependencies if needed
if [ ! -d ".dart_tool" ]; then
    echo "📦 Installing dependencies..."
    dart pub get
fi

# Run the server
dart run bin/server.dart
