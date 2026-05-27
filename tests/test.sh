#!/bin/bash

# Execute pytest locally against structured criteria configurations
pytest /tests/test_outputs.py -v --tb=short
TEST_EXIT_CODE=$?

# Structural check output mapping for reward state isolation
mkdir -p /logs/verifier

if [ $TEST_EXIT_CODE -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi