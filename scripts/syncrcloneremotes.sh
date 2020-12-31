#!/bin/bash

# Sync Google Drive
rclonesync /home/filip/GDrive gdrive:/ --rclone-args --drive-export-formats link.html

# Sync Dropbox
rclonesync /home/filip/Dropbox dropbox:/

