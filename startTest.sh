#!/usr/bin/env bash
echo  "{Epicture.} - Automated Tests\n"

echo "-- ALBUM"
flutter test test/album_test.dart
sleep 1

echo "-- MANAGE ALBUM"
flutter test test/manage_album_test.dart
sleep 1

echo "-- MANAGE IMAGE"
flutter test test/manage_image_test.dart
sleep 1

echo "-- UPLOAD"
flutter test test/upload_test.dart
sleep 1

echo "-- COMMENT"
flutter test test/comment_test.dart
sleep 1

echo "-- ADD/REMOVE IMAGE FROM AN ALBUM"
flutter test test/add_image_to_album_test.dart

echo "DONE!"
sleep 5