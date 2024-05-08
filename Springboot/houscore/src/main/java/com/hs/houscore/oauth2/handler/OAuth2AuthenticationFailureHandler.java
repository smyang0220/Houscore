package com.hs.houscore.oauth2.handler;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;
import java.io.IOException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
@Component
public class OAuth2AuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {
    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                        AuthenticationException exception) throws IOException {
        // HTTP 상태 코드를 401로 설정
        response.setStatus(HttpStatus.UNAUTHORIZED.value());
        // JSON 형식의 응답을 반환
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        // 오류 메시지를 JSON 형식으로 클라이언트에게 전달
        response.getWriter().write("{\"error\":\"Unauthorized\", \"message\":\"" + exception.getLocalizedMessage() + "\"}");
    }
}
