#!/bin/sh

echo 'STARTING MIGRATIONS'
$RELEASE_ROOT_DIR/bin/rp_server command Elixir.RpCore.ReleaseTasks migrate