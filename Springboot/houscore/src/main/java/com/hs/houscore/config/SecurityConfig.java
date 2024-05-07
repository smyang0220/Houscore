package com.hs.houscore.config;

import com.hs.houscore.jwt.filter.JwtAuthenticationFilter;
import com.hs.houscore.jwt.service.JwtService;
import com.hs.houscore.postgre.service.MemberService;
import com.hs.houscore.oauth2.HttpOAuth2AuthorizationRequestRepository;
import com.hs.houscore.oauth2.handler.OAuth2AuthenticationFailureHandler;
import com.hs.houscore.oauth2.handler.OAuth2AuthenticationSuccessHandler;
import com.hs.houscore.oauth2.service.CustomOAuth2MemberService;
import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.annotation.web.configurers.HeadersConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final CustomOAuth2MemberService customOAuth2MemberService;
    private final OAuth2AuthenticationSuccessHandler oAuth2AuthenticationSuccessHandler;
    private final OAuth2AuthenticationFailureHandler oAuth2AuthenticationFailureHandler;
    private final HttpOAuth2AuthorizationRequestRepository httpOAuth2AuthorizationRequestRepository;
    private final JwtService jwtService;

    public SecurityConfig( // 순환문제 때문에 lazy 사용해서 생성자 만들기
                           CustomOAuth2MemberService customOAuth2MemberService,
                           OAuth2AuthenticationSuccessHandler oAuth2AuthenticationSuccessHandler,
                           OAuth2AuthenticationFailureHandler oAuth2AuthenticationFailureHandler,
                           HttpOAuth2AuthorizationRequestRepository httpOAuth2AuthorizationRequestRepository,
                           JwtService jwtService,
                           @Lazy MemberService memberService) {
        this.customOAuth2MemberService = customOAuth2MemberService;
        this.oAuth2AuthenticationSuccessHandler = oAuth2AuthenticationSuccessHandler;
        this.oAuth2AuthenticationFailureHandler = oAuth2AuthenticationFailureHandler;
        this.httpOAuth2AuthorizationRequestRepository = httpOAuth2AuthorizationRequestRepository;
        this.jwtService = jwtService;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.csrf(AbstractHttpConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .headers(headersConfigurer -> headersConfigurer.frameOptions(HeadersConfigurer.FrameOptionsConfig::disable)) // For H2 DB
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests((requests) -> requests
                        .requestMatchers("/**","/oauth2/**", "/kakaologin/**", "/login/**",
                                "/swagger-ui/**", "/v3/api-docs/**", "/api/**", "/swagger-resources/**", "/webjars/**").permitAll()
                        .anyRequest().authenticated()
                )
                .sessionManagement(sessions -> sessions.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .oauth2Login(configure ->
                        configure.authorizationEndpoint(config -> config.authorizationRequestRepository(httpOAuth2AuthorizationRequestRepository))
                                .userInfoEndpoint(config -> config.userService(customOAuth2MemberService))
                                .successHandler(oAuth2AuthenticationSuccessHandler)
                                .failureHandler(oAuth2AuthenticationFailureHandler)
                )
                .addFilterBefore(new JwtAuthenticationFilter(jwtService), UsernamePasswordAuthenticationFilter.class);
        // 로그아웃 후 .addFilterAfter(); 추가 필요

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.addAllowedOriginPattern("http://k10s206.p.ssafy.io:8084");
        configuration.addAllowedOriginPattern("https://k10s206.p.ssafy.io");
        configuration.addAllowedOriginPattern("*"); // 프론트 배포 전까지만 허용
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "DELETE", "PATCH", "PUT"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}