#!/bin/ash

set -e

echo "-- Running migrations..."
$HOME/bin/pleroma_ctl migrate

echo "-- Starting!"
exec $HOME/bin/pleroma start
