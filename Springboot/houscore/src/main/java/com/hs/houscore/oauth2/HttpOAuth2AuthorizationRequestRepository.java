package com.hs.houscore.oauth2;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.oauth2.client.web.AuthorizationRequestRepository;
import org.springframework.security.oauth2.core.endpoint.OAuth2AuthorizationRequest;
import org.springframework.stereotype.Component;

@Component
public class HttpOAuth2AuthorizationRequestRepository
        implements AuthorizationRequestRepository<OAuth2AuthorizationRequest> {
    private static final String OAUTH2_AUTHORIZATION_REQUEST_ATTR_NAME = "oauth2_auth_request";
    private static final String REDIRECT_URI_PARAM_ATTR_NAME = "redirect_uri";
    private static final String MODE_PARAM_ATTR_NAME = "mode";

    @Override
    public OAuth2AuthorizationRequest loadAuthorizationRequest(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (OAuth2AuthorizationRequest) session.getAttribute(OAUTH2_AUTHORIZATION_REQUEST_ATTR_NAME);
        }
        return null;
    }

    @Override
    public void saveAuthorizationRequest(OAuth2AuthorizationRequest authorizationRequest, HttpServletRequest request,
                                         HttpServletResponse response) {
        if (authorizationRequest == null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute(OAUTH2_AUTHORIZATION_REQUEST_ATTR_NAME);
                session.removeAttribute(REDIRECT_URI_PARAM_ATTR_NAME);
                session.removeAttribute(MODE_PARAM_ATTR_NAME);
            }
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute(OAUTH2_AUTHORIZATION_REQUEST_ATTR_NAME, authorizationRequest);

        String redirectUriAfterLogin = request.getParameter(REDIRECT_URI_PARAM_ATTR_NAME);
        if (redirectUriAfterLogin != null) {
            session.setAttribute(REDIRECT_URI_PARAM_ATTR_NAME, redirectUriAfterLogin);
        }

        String mode = request.getParameter(MODE_PARAM_ATTR_NAME);
        if (mode != null) {
            session.setAttribute(MODE_PARAM_ATTR_NAME, mode);
        }
    }

    @Override
    public OAuth2AuthorizationRequest removeAuthorizationRequest(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            OAuth2AuthorizationRequest authRequest = (OAuth2AuthorizationRequest) session.getAttribute(OAUTH2_AUTHORIZATION_REQUEST_ATTR_NAME);
            session.removeAttribute(OAUTH2_AUTHORIZATION_REQUEST_ATTR_NAME);
            return authRequest;
        }
        return null;
    }
}
