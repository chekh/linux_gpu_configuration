#!/bin/bash

# Install Ray if specified in the config
if [ "$RAY_INSTALL" == "true" ]; then
  echo "Installing Ray..."
  pip3 install ray
fi
