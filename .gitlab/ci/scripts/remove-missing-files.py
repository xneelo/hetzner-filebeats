import os

# Get the CHANGED_FILES environment variable and split it into a list
changed_files = os.environ.get("CHANGED_FILES", "").split()

# Check if each file in the list exists on disk
existing_files = []
for file in changed_files:
    if os.path.isfile(file):
        existing_files.append(file)

# Output the remaining files as a space-separated string
print(" ".join(existing_files))
