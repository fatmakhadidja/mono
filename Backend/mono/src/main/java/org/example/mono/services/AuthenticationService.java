package org.example.mono.services;

import lombok.RequiredArgsConstructor;
import org.example.mono.auth.AuthenticationRequest;
import org.example.mono.auth.AuthenticationResponse;
import org.example.mono.auth.RegisterRequest;
import org.example.mono.models.User;
import org.example.mono.repositories.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

    @Autowired
 private UserRepo userRepo;

 private final PasswordEncoder passwordEncoder;

 private final JwtService jwtService;

 private final AuthenticationManager authenticationManager;


    public AuthenticationResponse register(RegisterRequest request) {
        // Check if email already exists
        if (userRepo.findByEmail(request.getEmail()).isPresent()) {
            throw new RuntimeException("Email already exists");
        }
        var user = User.builder().fullName(request.getFullName()).
                email(request.getEmail()).
                role(User.Role.USER).
                password(passwordEncoder.encode(request.getPassword())).
                build();
        userRepo.save(user);

        var jwtToken = jwtService.generateToken(user);
        return AuthenticationResponse.builder()
                .id(user.getId())
                .token(jwtToken)
                .fullname(user.getFullName())
                .build();    }




    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );
        var user = userRepo.findByEmail(request.getEmail())
                .orElseThrow();
        var jwtToken = jwtService.generateToken(user);

//        var refreshToken = jwtService.generateRefreshToken(user);
//        revokeAllUserTokens(user);
//        saveUserToken(user, jwtToken);

        return AuthenticationResponse.builder()
                .id(user.getId())
                .token(jwtToken)
                .fullname(user.getFullName())
                .build();
    }
}
