#!/bin/bash

# Test Runner Script for D&D Sales App
# This script provides convenient commands for running different types of tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}D&D Sales App - Test Runner${NC}"
echo "================================"
echo ""

# Parse command line arguments
TEST_TYPE=${1:-all}

case $TEST_TYPE in
  unit)
    echo -e "${YELLOW}Running Unit Tests...${NC}"
    flutter test test/unit/
    ;;
  
  widget)
    echo -e "${YELLOW}Running Widget Tests...${NC}"
    flutter test test/widget/
    ;;
  
  integration)
    echo -e "${YELLOW}Running Integration Tests...${NC}"
    flutter test test/integration/
    ;;
  
  e2e)
    echo -e "${YELLOW}Running End-to-End Tests...${NC}"
    flutter test integration_test/
    ;;
  
  coverage)
    echo -e "${YELLOW}Running All Tests with Coverage...${NC}"
    flutter test --coverage
    echo ""
    echo -e "${GREEN}Coverage report generated: coverage/lcov.info${NC}"
    echo "To view HTML report, run: genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html"
    ;;
  
  all)
    echo -e "${YELLOW}Running All Tests...${NC}"
    flutter test
    ;;
  
  smoke)
    echo -e "${YELLOW}Running Smoke Tests...${NC}"
    flutter test test/widget_test.dart
    ;;
  
  help|--help|-h)
    echo "Usage: ./run_tests.sh [TEST_TYPE]"
    echo ""
    echo "TEST_TYPE options:"
    echo "  all         - Run all tests (default)"
    echo "  unit        - Run unit tests only"
    echo "  widget      - Run widget tests only"
    echo "  integration - Run integration tests only"
    echo "  e2e         - Run end-to-end tests only"
    echo "  coverage    - Run all tests with coverage report"
    echo "  smoke       - Run smoke tests only"
    echo "  help        - Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./run_tests.sh"
    echo "  ./run_tests.sh unit"
    echo "  ./run_tests.sh coverage"
    exit 0
    ;;
  
  *)
    echo -e "${RED}Invalid test type: $TEST_TYPE${NC}"
    echo "Run './run_tests.sh help' for usage information"
    exit 1
    ;;
esac

# Check if tests passed
if [ $? -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✓ All tests passed!${NC}"
else
  echo ""
  echo -e "${RED}✗ Some tests failed!${NC}"
  exit 1
fi
