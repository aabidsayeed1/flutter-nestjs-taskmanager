enum UserRoleType {
  owner,
  admin,
  user,
  unknown;

  static UserRoleType fromString(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return UserRoleType.owner;
      case 'admin':
        return UserRoleType.admin;
      case 'user':
        return UserRoleType.user;
      default:
        return UserRoleType.unknown;
    }
  }

  String toRuleString() {
    switch (this) {
      case UserRoleType.owner:
        return 'Owner';
      case UserRoleType.admin:
        return 'Admin';
      case UserRoleType.user:
        return 'User';
      default:
        return 'Unknown';
    }
  }
}
