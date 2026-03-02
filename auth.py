from functools import wraps

from flask import request, abort



def require_token(config):
    expected_token = config.access_token

    def decorator(view_func):
        @wraps(view_func)
        def wrapper(*args, **kwargs):
            token: str = request.headers.get("Authorization", "")

            if expected_token and token != f"Bearer {expected_token}":
                abort(401, description="Unauthorized")

            return view_func(*args, **kwargs)
        return wrapper
    return decorator
