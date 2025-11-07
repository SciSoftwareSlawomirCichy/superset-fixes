#!/usr/bin/env python3
"""
Healthcheck script for Apache Superset

This script checks if Superset is responding correctly.
Exit code 0 means healthy, non-zero means unhealthy.
"""

import sys
import urllib.request
import urllib.error

def check_health(host="localhost", port=8088):
    """Check if Superset is healthy."""
    try:
        url = f"http://{host}:{port}/health"
        response = urllib.request.urlopen(url, timeout=5)
        
        if response.status == 200:
            print("✓ Superset is healthy")
            return 0
        else:
            print(f"✗ Superset returned status code {response.status}")
            return 1
            
    except urllib.error.URLError as e:
        print(f"✗ Failed to connect to Superset: {e}")
        return 1
    except Exception as e:
        print(f"✗ Health check failed: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(check_health())
