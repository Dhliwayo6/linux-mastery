package com.linuxmastery.dto.response;

import com.linuxmastery.entity.Role;

public record AdminUserResponse(
    String id,
    String displayName,
    String email,
    Role role,
    long modulesCompleted
) {}
