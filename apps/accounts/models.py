from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    storage_quota_bytes = models.BigIntegerField(default=5 * 1024 * 1024 * 1024)  # 5 GB

    class Meta:
        db_table = "accounts_user"