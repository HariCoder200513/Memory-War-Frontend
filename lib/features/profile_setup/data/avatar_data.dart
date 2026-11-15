import 'package:flutter/material.dart';

enum AvatarShape { circle, triangle, diamond, square, star, hexagon, plus, drop }

class AvatarOption {
  final String id;
  final String name;
  final AvatarShape shape;
  final Color backgroundColor;
  final Color shapeColor;

  const AvatarOption({
    required this.id,
    required this.name,
    required this.shape,
    required this.backgroundColor,
    required this.shapeColor,
  });
}

const avatarOptions = [
  AvatarOption(
    id: 'orbit',
    name: 'Orbit',
    shape: AvatarShape.circle,
    backgroundColor: Color(0xFFFFB547),
    shapeColor: Color(0xFF3D2E00),
  ),
  AvatarOption(
    id: 'peak',
    name: 'Peak',
    shape: AvatarShape.triangle,
    backgroundColor: Color(0xFF4DD4AC),
    shapeColor: Color(0xFF0A3D2E),
  ),
  AvatarOption(
    id: 'gem',
    name: 'Gem',
    shape: AvatarShape.diamond,
    backgroundColor: Color(0xFF6BCB77),
    shapeColor: Color(0xFF1A3D1F),
  ),
  AvatarOption(
    id: 'block',
    name: 'Block',
    shape: AvatarShape.square,
    backgroundColor: Color(0xFFFF7979),
    shapeColor: Color(0xFF3D1A1A),
  ),
  AvatarOption(
    id: 'nova',
    name: 'Nova',
    shape: AvatarShape.star,
    backgroundColor: Color(0xFF7B68EE),
    shapeColor: Color(0xFF1A1540),
  ),
  AvatarOption(
    id: 'hive',
    name: 'Hive',
    shape: AvatarShape.hexagon,
    backgroundColor: Color(0xFFFF6B9D),
    shapeColor: Color(0xFF3D1028),
  ),
  AvatarOption(
    id: 'plus',
    name: 'Plus',
    shape: AvatarShape.plus,
    backgroundColor: Color(0xFF2D2B3D),
    shapeColor: Color(0xFF6BCB77),
  ),
  AvatarOption(
    id: 'drop',
    name: 'Drop',
    shape: AvatarShape.drop,
    backgroundColor: Color(0xFFFFCBA4),
    shapeColor: Color(0xFF3D2A14),
  ),
];
