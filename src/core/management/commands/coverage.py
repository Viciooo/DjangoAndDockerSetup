"""
Django command to test coverage.
"""
import os

from django.core.management.base import BaseCommand


class Command(BaseCommand):
    """Django command to test coverage."""

    def handle(self, *args, **options):
        """Entrypoint for command."""
        self.stdout.write("Testing coverage...")
        os.system("coverage run -m unittest discover && coverage report -m --fail-under=100")

        self.stdout.write(self.style.SUCCESS("Coverage tested!"))
