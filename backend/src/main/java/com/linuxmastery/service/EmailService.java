package com.linuxmastery.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class EmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @org.springframework.beans.factory.annotation.Value("${cors.allowed-origins:http://localhost:5173}")
    private String frontendUrl;

    @org.springframework.beans.factory.annotation.Value("${spring.mail.from:noreply@linuxmastery.com}")
    private String fromEmail;

    public void sendPasswordResetEmail(String toEmail, String resetToken) {
        log.info("Sending password reset email to {}", toEmail);
        if (mailSender == null) {
            log.warn("JavaMailSender not configured, skipping email send");
            return;
        }
        try {
            String baseFrontendUrl = frontendUrl.split(",")[0].trim();
            String resetLink = baseFrontendUrl + "/auth/reset-password?token=" + resetToken;

            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("Linux Mastery - Password Reset Request");
            message.setText("To reset your password, click the link below:\n\n" 
                + resetLink + "\n\nThis link expires in 30 minutes.");
            mailSender.send(message);
        } catch (Exception e) {
            log.error("Failed to send email to {}", toEmail, e);
        }
    }

    public void sendRegistrationOtpEmail(String toEmail, String otp) {
        log.info("Sending registration OTP email to {}", toEmail);
        if (mailSender == null) {
            log.warn("JavaMailSender not configured, skipping email send");
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("Linux Mastery - Registration OTP Verification");
            message.setText("Welcome to Linux Mastery!\n\n"
                + "Your registration verification OTP code is: " + otp + "\n\n"
                + "This code will expire in 15 minutes.");
            mailSender.send(message);
        } catch (Exception e) {
            log.error("Failed to send registration OTP email to {}", toEmail, e);
        }
    }

    public void sendPasswordResetOtpEmail(String toEmail, String otp) {
        log.info("Sending password reset OTP email to {}", toEmail);
        if (mailSender == null) {
            log.warn("JavaMailSender not configured, skipping email send");
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("Linux Mastery - Password Reset OTP");
            message.setText("We received a request to reset your password.\n\n"
                + "Your password reset OTP code is: " + otp + "\n\n"
                + "This code will expire in 15 minutes.");
            mailSender.send(message);
        } catch (Exception e) {
            log.error("Failed to send password reset OTP email to {}", toEmail, e);
        }
    }
}

