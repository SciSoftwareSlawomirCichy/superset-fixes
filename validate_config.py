#!/usr/bin/env python3
"""
Configuration Validation Script for Apache Superset

This script validates the superset_config.py file and checks for common issues.
"""

import os
import sys
import importlib.util

def validate_config():
    """Validate the Superset configuration file."""
    print("=" * 60)
    print("Apache Superset Configuration Validation")
    print("=" * 60)
    print()
    
    # Check if config file exists
    config_path = "superset_config.py"
    if not os.path.exists(config_path):
        print("❌ ERROR: superset_config.py not found!")
        return False
    print(f"✓ Configuration file found: {config_path}")
    
    # Try to import the config
    try:
        spec = importlib.util.spec_from_file_location("superset_config", config_path)
        config = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(config)
        print("✓ Configuration file is valid Python")
    except Exception as e:
        print(f"❌ ERROR: Failed to load configuration: {e}")
        return False
    
    # Check required settings
    required_settings = [
        'SECRET_KEY',
        'SQLALCHEMY_DATABASE_URI',
        'WTF_CSRF_ENABLED',
    ]
    
    print("\nChecking required settings:")
    for setting in required_settings:
        if hasattr(config, setting):
            value = getattr(config, setting)
            # Mask sensitive values
            if setting == 'SECRET_KEY':
                if value == 'CHANGE_ME_TO_A_COMPLEX_RANDOM_SECRET':
                    print(f"  ⚠️  {setting}: Default value (should be changed for production!)")
                else:
                    print(f"  ✓ {setting}: Set (value hidden)")
            else:
                print(f"  ✓ {setting}: {value}")
        else:
            print(f"  ❌ {setting}: Missing!")
            return False
    
    # Check optional but recommended settings
    print("\nChecking optional settings:")
    optional_settings = {
        'CACHE_CONFIG': 'Caching configuration',
        'FEATURE_FLAGS': 'Feature flags',
        'LANGUAGES': 'Language support',
        'CORS_OPTIONS': 'CORS configuration',
    }
    
    for setting, description in optional_settings.items():
        if hasattr(config, setting):
            print(f"  ✓ {setting}: Configured ({description})")
        else:
            print(f"  ℹ️  {setting}: Not set ({description})")
    
    # Security checks
    print("\nSecurity checks:")
    if hasattr(config, 'SECRET_KEY'):
        secret_key = getattr(config, 'SECRET_KEY')
        if 'CHANGE_ME' in secret_key or len(secret_key) < 20:
            print("  ⚠️  SECRET_KEY should be changed to a strong random value!")
            print("     Generate one with: openssl rand -base64 42")
        else:
            print("  ✓ SECRET_KEY appears to be properly configured")
    
    if hasattr(config, 'WTF_CSRF_ENABLED'):
        if getattr(config, 'WTF_CSRF_ENABLED'):
            print("  ✓ CSRF protection is enabled")
        else:
            print("  ⚠️  CSRF protection is disabled!")
    
    print("\n" + "=" * 60)
    print("Validation complete!")
    print("=" * 60)
    return True

if __name__ == "__main__":
    success = validate_config()
    sys.exit(0 if success else 1)
