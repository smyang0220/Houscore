package com.hs.houscore.oauth2.service;

import com.hs.houscore.oauth2.member.OAuth2MemberInfo;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

public class OAuth2MemberPrincipal implements OAuth2User, UserDetails {

    private final OAuth2MemberInfo memberInfo;

    public OAuth2MemberPrincipal(OAuth2MemberInfo memberInfo) {
        this.memberInfo = memberInfo;
    }

    @Override
    public String getPassword() {
        return null;
    }

    @Override
    public String getUsername() {
        return memberInfo.getEmail();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return memberInfo.getAttributes();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.emptyList();
    }

    @Override
    public String getName() {
        return memberInfo.getMemberName();
    }

    public OAuth2MemberInfo getUserInfo() {
        return memberInfo;
    }
}
