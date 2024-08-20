#!/bin/bash

# Install Jupyter Notebook if specified in the config
if [ "$JUPYTER_INSTALL" == "true" ]; then
  echo "Installing Jupyter Notebook..."
  pip3 install jupyter
  jupyter notebook --no-browser --port=$JUPYTER_PORT &
fi
