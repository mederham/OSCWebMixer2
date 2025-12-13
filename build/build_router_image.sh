#!/bin/bash

if ! which skopeo > /dev/null 2>&1; then
    echo "Error: The skopeo utility is not installed."
fi

# Parameters with defaults
IMAGE_NAME="${1:-oscwebmixer2}"
ARCHIVE_FILE="${2:-${IMAGE_NAME}-router.tar}"

# Build the image for ARM architecture
echo "Building image for ARM..."
docker build --no-cache --platform linux/arm -t "${IMAGE_NAME}:latest" .

# Verify the image was built successfully
if ! docker images "${IMAGE_NAME}:latest" | grep -q "${IMAGE_NAME}"; then
    echo "Error: Image build failed"
    exit 1
fi

# Create archive file
rm -f "${ARCHIVE_FILE}"
echo "Creating archive file..."
skopeo copy docker-daemon:${IMAGE_NAME}:latest docker-archive:${ARCHIVE_FILE}

# Verify archive creation
if [ ! -f "${ARCHIVE_FILE}" ]; then
    echo "Error: Archive file not created"
    exit 1
fi

echo "Success: Image built and archived as ${ARCHIVE_FILE}"