.Model small

.DATA

    ; Account number
    PROMPT_ACCOUNT_NUMBER DB 10,13, " Enter your account number: $"
    ERROR_ACCOUNT_NOT_FOUND DB 10,13, "---------- Account number does not exist. please try again! ---------$"
    VALID_ACCOUNT_NUMBER DB "1234$"
    ACCOUNT_NUMBER_LENGTH DW $-(OFFSET VALID_ACCOUNT_NUMBER)-1
    ENTERED_ACCOUNT_LENGTH DW 0H
    
    ; Password data
    PROMPT_PASSWORD DB 10,13, " Enter your password: $"
    ERROR_INVALID_PASSWORD DB 10,13, "---------- Invalid password please try again! ---------- $"
    VALID_PASSWORD DB "test$"
    PASSWORD_LENGTH DW $-(OFFSET VALID_PASSWORD)-1
    ENTERED_PASSWORD_LENGTH DW 0H
 ; Menu options
    WELCOME_MESSAGE DB 10,13,10,13, "**************************  Welcome to your account  ***************************$"
    OPTION_CHECK_BALANCE DB 10,13, " 1. Check your balance$"
    OPTION_WITHDRAW_MONEY DB 10,13, " 2. Withdraw money$"
    OPTION_DEPOSIT_MONEY DB 10,13, " 3. Deposit money$"
    OPTION_EXIT DB 10,13, " 4. Exit$"
    
    ; Messages
    THANK_YOU_MESSAGE DB 10,13,10,13, "                          Thank you for banking with us!$"
    ERROR_INVALID_OPTION DB 10,13, " Invalid input Please choose any key to continue.$"
    PROMPT_OPTION DB 0AH, 10,13, " Enter option: $"
    SUCCESS_TRANSACTION DB 10,13, " Transaction successful$"
    ERROR_LIMIT_EXCEEDED DB 10,13, " Limit exceeded $"
    new db 10,13,"$"

       
    ; Balance
    CURRENT_BALANCE DW 25000
    MESSAGE_CURRENT_BALANCE DB 10,13, " Current balance =  $"
    
    ; Withdraw
    PROMPT_WITHDRAW_AMOUNT DB 10,13, " Enter amount to withdraw:  $"
    WITHDRAW_AMOUNT DW 0H 
    ERROR_INSUFFICIENT_BALANCE DB 10,13, " Insufficient balance$"
    
    ; Deposit
    PROMPT_DEPOSIT_AMOUNT DB 10,13, " Enter amount to deposit:  $"
    DEPOSIT_AMOUNT DW 0H
            
    ; Amount options
    OPTION_AMOUNT_ABOVE_1000 DB 10,13, " 1. 1000 - 9000$"
    OPTION_AMOUNT_ABOVE_100 DB 10,13, " 2. 100 - 999$" 
    MAXIMUM_LIMIT DW 9000
    MINIMUM_LIMIT DW 100
    
    ; Digit place values
    THOUSAND DW 1000
    HUNDRED DB 100
    TEN DB 10
    
    
    .CODE
    start:
    .startup
    
    ; Check account number
    LEA SI, VALID_ACCOUNT_NUMBER ; Store offset of existing account number in SI
    MOV CX, ACCOUNT_NUMBER_LENGTH ; Loop ACCOUNT_NUMBER_LENGTH times as account number is ACCOUNT_NUMBER_LENGTH characters long
    
    LEA DX, PROMPT_ACCOUNT_NUMBER
    MOV AH, 9
    INT 21H
    
    
    VERIFY_ACCOUNT:
                    MOV AH,1
                    INT 21H
                    
                    CMP AL, 13
                    JE BREAK_ACCOUNT_VERIFICATION
                    
                    INC ENTERED_ACCOUNT_LENGTH
                    CMP AL, [SI] ; Compare with actual account number
                    JNE SET_ACCOUNT_FLAG
                    JMP CONTINUE_ACCOUNT_VERIFICATION
                             
        SET_ACCOUNT_FLAG: MOV BL, 1 ; bl set to 1 and as i last we check bl is it is 1 then account not match
                             
        CONTINUE_ACCOUNT_VERIFICATION:
                    INC SI
                    JMP VERIFY_ACCOUNT
                    
BREAK_ACCOUNT_VERIFICATION:      
                            
                                CMP CX, ENTERED_ACCOUNT_LENGTH
                                JL ACCOUNT_VERIFICATION_FAILED
                                JG ACCOUNT_VERIFICATION_FAILED
                               
                                CMP BL, 1
                                JE ACCOUNT_VERIFICATION_FAILED
                                JNE RETURN_TO_PASSWORD_CHECK
                                 
                                
    ACCOUNT_VERIFICATION_FAILED: 
                                 MOV ENTERED_ACCOUNT_LENGTH, 0
                                 MOV BL, 0
                                 LEA DX, new
                                 MOV AH, 09H
                                 INT 21H
                                 LEA DX, ERROR_ACCOUNT_NOT_FOUND
                                 MOV AH, 09H
                                 INT 21H
                                 
                                 LEA DX, new
                                 MOV AH, 09H
                                 INT 21H
                                 LEA DX, PROMPT_ACCOUNT_NUMBER
                                 MOV AH, 9
                                 INT 21H 
                                 
                                 MOV SI,0
                                 mov cx,0
                                 LEA SI, VALID_ACCOUNT_NUMBER
                                 MOV CX, ACCOUNT_NUMBER_LENGTH
                                 jmp VERIFY_ACCOUNT 
                                   
    RETURN_TO_PASSWORD_CHECK: 
     ; Check password
    LEA DX, PROMPT_PASSWORD
    MOV AH, 09H
    INT 21H
    
    CALL VERIFY_PASSWORD
    JMP DISPLAY_MENU      
    
                    


 ; Display the menu
    DISPLAY_MENU: MOV AH, 9
                  LEA DX, WELCOME_MESSAGE
                  INT 21H
                  
                  MOV AH, 9
                  LEA DX, OPTION_CHECK_BALANCE
                  INT 21H
                  
                  MOV AH, 9
                  LEA DX, OPTION_WITHDRAW_MONEY
                  INT 21H
                  
                  MOV AH, 9
                  LEA DX, OPTION_DEPOSIT_MONEY
                  INT 21H
                  
                  MOV AH, 9
                  LEA DX, OPTION_EXIT
                  INT 21H
                  
                  MOV AH, 9
                  LEA DX, PROMPT_OPTION
                  INT 21H
                  
                  MOV AH, 1
                  INT 21H

; Comparing with ASCII code of decimal numbers
                  CMP AL, 49
                  JE DISPLAY_BALANCE
                  
                  CMP AL, 50
                  JE PROCESS_WITHDRAWAL
                  
                  CMP AL, 51
                  JE PROCESS_DEPOSIT
                  
                  CMP AL, 52
                  JE EXIT_APPLICATION
                  
                  JMP INPUT_ERROR

 ; Display the current balance
    DISPLAY_BALANCE: 
                     
                     MOV AH, 09H
                     LEA DX, MESSAGE_CURRENT_BALANCE
                     INT 21H
                       
                     XOR AX, AX
                     MOV AX, CURRENT_BALANCE
                     CALL DISPLAY_NUMBER
                     jmp RETURN_TO_MENU

  ; Withdraw money from account
        PROCESS_WITHDRAWAL:                        
                            MOV AH, 09H
                            LEA DX, new
                            INT 21H
                            
                            MOV AH, 09H
                            LEA DX, OPTION_AMOUNT_ABOVE_1000
                            INT 21H
                            
                            MOV AH, 09H
                            LEA DX, OPTION_AMOUNT_ABOVE_100
                            INT 21H
                            
                            MOV AH, 09H
                            LEA DX, new
                            INT 21H
                            
                            MOV AH, 09H
                            LEA DX, PROMPT_OPTION
                            INT 21H
                            
                            MOV AH, 01H
                            INT 21H
                            
                            ; Check withdrawal amount option
                            CMP AL, 49
                            JE WITHDRAW_ABOVE_1000
                            CMP AL, 50
                            JE WITHDRAW_ABOVE_100
                            JMP INPUT_ERROR

 ; If withdrawal amount is between 1000 and 9000
    WITHDRAW_ABOVE_1000:
                        MOV AH, 09H
                        LEA DX, PROMPT_WITHDRAW_AMOUNT
                        INT 21H
                                  
                        CALL INPUT_4_DIGIT_NUMBER
                        MOV WITHDRAW_AMOUNT, BX
                        
                        CMP BX, MAXIMUM_LIMIT
                        JG ERROR_WITHDRAWAL_LIMIT_EXCEEDED
                        JMP PROCESS_WITHDRAW_TRANSACTION
                        
                         ; If withdrawal amount is between 100 and 999
    WITHDRAW_ABOVE_100: MOV AH, 09H
                        LEA DX, PROMPT_WITHDRAW_AMOUNT
                        INT 21H
                                  
                        CALL INPUT_3_DIGIT_NUMBER
                        MOV WITHDRAW_AMOUNT, BX
                        
                        JMP PROCESS_WITHDRAW_TRANSACTION                
    
    
    ; Start the withdrawal transaction
    PROCESS_WITHDRAW_TRANSACTION:
                                 CMP BX, CURRENT_BALANCE
                                 JG ERROR_INSUFFICIENT_WITHDRAWAL_BALANCE
                                 
                                 MOV BX, CURRENT_BALANCE
                                 SUB BX, WITHDRAW_AMOUNT
                                 MOV CURRENT_BALANCE, BX
                                     
                                 MOV AH, 0
                                 INT 16H
                                 lea dx, new
                                 mov ah,2
                                 int 21h
                                 CALL DISPLAY_SUCCESS_MESSAGE
                                 JMP RETURN_TO_MENU
 ; If the current balance is lower than the withdrawal amount
    ERROR_INSUFFICIENT_WITHDRAWAL_BALANCE: 
                                 MOV AH, 0H
                                 INT 16H
                                 MOV AH, 09H
                                 LEA DX, ERROR_INSUFFICIENT_BALANCE
                                 INT 21H
                                 JMP RETURN_TO_MENU       
                    
                    
                    
    ; Deposit money to account
    PROCESS_DEPOSIT: 
                     MOV AH, 9
                     LEA DX, new
                     INT 21H
                     
                     MOV AH, 9
                     LEA DX, OPTION_AMOUNT_ABOVE_1000
                     INT 21H
                      
                     MOV AH, 9
                     LEA DX, OPTION_AMOUNT_ABOVE_100
                     INT 21H
                     
                     MOV AH, 9
                     LEA DX, new
                     INT 21H
                     
                     MOV AH, 9
                     LEA DX, PROMPT_OPTION
                     INT 21H
                     
                     MOV AH,1
                     INT 21H
  ; Check deposit amount option
                     CMP AL, 49
                     JE DEPOSIT_ABOVE_1000
                     CMP AL, 50
                     JE DEPOSIT_ABOVE_100
                     JMP INPUT_ERROR 
    
                     
    ; If deposit amount is between Rs.1000 and Rs.5000
    DEPOSIT_ABOVE_1000: MOV AH, 9
                        LEA DX, PROMPT_DEPOSIT_AMOUNT
                        INT 21H
                                  
                        CALL INPUT_4_DIGIT_NUMBER
                        MOV DEPOSIT_AMOUNT, BX
                        
                        CMP BX, MAXIMUM_LIMIT
                        JG ERROR_DEPOSIT_LIMIT_EXCEEDED
                        JMP PROCESS_DEPOSIT_TRANSACTION
                                        
                    
    ; If deposit amount is between Rs.100 and Rs.999
    DEPOSIT_ABOVE_100: MOV AH, 09H
                       LEA DX, PROMPT_DEPOSIT_AMOUNT
                       INT 21H
                                  
                       CALL INPUT_3_DIGIT_NUMBER
                       MOV DEPOSIT_AMOUNT, BX
                       
                       JMP PROCESS_DEPOSIT_TRANSACTION
                       
                        ; Start the deposit transaction
    PROCESS_DEPOSIT_TRANSACTION: 
                                MOV BX, CURRENT_BALANCE
                                ADD BX, DEPOSIT_AMOUNT
                                MOV CURRENT_BALANCE, BX
                                    
                                MOV AH, 0
                                INT 16H
                                CALL DISPLAY_SUCCESS_MESSAGE
                                JMP RETURN_TO_MENU
                        
    
    ; Exit the application                 
    EXIT_APPLICATION: 
                     MOV AH, 9
                     LEA DX, new
                     INT 21H
                     
                     MOV AH, 09H
                     LEA DX, THANK_YOU_MESSAGE
                     INT 21H
                     
                     MOV AH, 4CH
                     INT 21H                   
    
    
    ; If user enters incorrect option
    INPUT_ERROR:   
                 MOV AH, 9
                 LEA DX, ERROR_INVALID_OPTION
                 INT 21H
                 
                 JMP RETURN_TO_MENU
  ; If amount exceeds specified limit
    ERROR_DEPOSIT_LIMIT_EXCEEDED: MOV AH, 0
                                   INT 16H
                                   MOV AH, 09H
                                   LEA DX, ERROR_LIMIT_EXCEEDED
                                   INT 21H
                                   JMP RETURN_TO_MENU
   ; Error handling for withdrawal limit exceeded
   ERROR_WITHDRAWAL_LIMIT_EXCEEDED:
    MOV AH, 09H
    LEA DX, ERROR_LIMIT_EXCEEDED
    INT 21H
    JMP RETURN_TO_MENU ; Return to the menu after displaying the error                                
                                
        
        
    ; Return to main menu
    RETURN_TO_MENU:
                    MOV AH, 0H
                    INT 16H                     
                    call screen_clear
                   JMP DISPLAY_MENU
 ; Procedure to input a 4-digit decimal number
    INPUT_4_DIGIT_NUMBER PROC 
        MOV AH, 1
        INT 21H
        
        ; Check whether character is a digit
        CMP AL, 48
        JL INPUT_ERROR
        CMP AL, 57
        JG INPUT_ERROR 
        
        sub AL, 48
        MOV AH, 0
        MUL THOUSAND ; 1st digit
        MOV BX, AX
        
        MOV AH, 1
        INT 21H
        
        ; Check whether character is a digit
        CMP AL, 48
        JL INPUT_ERROR
        CMP AL, 57
        JG INPUT_ERROR
        
        SUB AL, 48
        MUL HUNDRED ; 2nd digit
        ADD BX, AX
        
        MOV AH, 1
        INT 21H
 ; Check whether character is a digit
        CMP AL, 48
        JL INPUT_ERROR
        CMP AL, 57
        JG INPUT_ERROR
        
        SUB AL, 48
        MUL TEN ; 3rd digit
        ADD BX, AX               
        
        MOV AH, 1
        INT 21H
        
        ; Check whether character is a digit
        CMP AL, 48
        JL INPUT_ERROR
        CMP AL, 57
        JG INPUT_ERROR
        
        SUB AL, 48 ; 4th digit
        MOV AH, 0
        ADD BX, AX
        
        RET
 ; Procedure to input a 3-digit decimal number
    INPUT_3_DIGIT_NUMBER PROC NEAR
        MOV AH, 1
        INT 21H
        
        ; Check whether character is a digit
        CMP AL, 48
        JL INPUT_ERROR
        CMP AL, 57
        JG INPUT_ERROR
        
        SUB AL, 48
        MOV AH, 0
        MUL HUNDRED ; 1st digit
        MOV BX, AX
        
        MOV AH, 1
        INT 21H
        
        ; Check whether character is a digit
        CMP AL, 48
        JL INPUT_ERROR
        CMP AL, 57
        JG INPUT_ERROR
        
        SUB AL, 48
        MUL TEN ; 2nd digit
        ADD BX, AX               
        
        MOV AH, 01H
        INT 21H
 ; Check whether character is a digit
        CMP AL, 48
        JL INPUT_ERROR
        CMP AL, 57
        JG INPUT_ERROR
        
        SUB AL, 48 ; 3rd digit
        MOV AH, 0
        ADD BX, AX
        
        RET
 ; Procedure to display a 16-bit decimal number
    DISPLAY_NUMBER PROC 
        XOR CX, CX ; To count the digits
        MOV BX, 10 ; Fixed divider
        
        DIGITS:
        XOR DX, DX ; Zero DX for word division
        DIV BX
        PUSH DX ; Remainder (0,9)
        INC CX
        TEST AX, AX
        JNZ DIGITS ; Continue until AX is empty
        
        NEXT:
        POP DX
        ADD DL, 48
        MOV AH, 2
        INT 21H
        LOOP NEXT
        
        RET
; Procedure to display a successful transaction message
    DISPLAY_SUCCESS_MESSAGE PROC 
        MOV AH, 09H
        LEA DX, SUCCESS_TRANSACTION
        INT 21H
        
        MOV AH, 09H
        LEA DX, MESSAGE_CURRENT_BALANCE
        INT 21H
        
        XOR AX, AX
        MOV AX, CURRENT_BALANCE
        CALL DISPLAY_NUMBER
        
        RET
; Procedure to verify password
    VERIFY_PASSWORD PROC 
       ; MOV ENTERED_PASSWORD_LENGTH, 0H
        MOV BL, 0 ; Flag stored in BL
        LEA SI, VALID_PASSWORD ; Store offset of correct password in SI
        MOV CX, PASSWORD_LENGTH ; Length of entered password has to be compared with actual password length.
        
        VERIFY_PASSWORD_LOOP: MOV AH,8 ; Character input without echo to output device.
                              INT 21H
                              
                              CMP AL, 13 ; Break if user presses enter key.
                              JE BREAK_PASSWORD_VERIFICATION
                                  
                              INC ENTERED_PASSWORD_LENGTH
                              CMP AL, [SI] ; Compare with actual password.
                              JNE SET_PASSWORD_FLAG
                              JE CONTINUE_PASSWORD_VERIFICATION
                                 
               SET_PASSWORD_FLAG: MOV BL, 01H
                             
               CONTINUE_PASSWORD_VERIFICATION:
                                MOV AH, 2 
                                MOV DL, 42 ; Hide password characters with *.
                                INT 21H
                                                    
                              INC SI
                              JMP VERIFY_PASSWORD_LOOP
                              
               BREAK_PASSWORD_VERIFICATION:
                                     CMP CX, ENTERED_PASSWORD_LENGTH
                                      JL PASSWORD_VERIFICATION_FAILED
                                      JG PASSWORD_VERIFICATION_FAILED
                                         
                                      CMP BL, 1
                                      JE PASSWORD_VERIFICATION_FAILED
                                      JNE RETURN_FROM_PASSWORD_CHECK
                                  
        PASSWORD_VERIFICATION_FAILED:
                                 MOV ENTERED_PASSWORD_LENGTH, 0
                                 MOV BL, 0 
                                 LEA DX, new
                                 MOV AH, 09H
                                 INT 21H
                                 LEA DX, ERROR_INVALID_PASSWORD
                                 MOV AH, 09H
                                 INT 21H
                                 
                                 LEA DX, new
                                 MOV AH, 09H
                                 INT 21H
                                 mov si,0
                                 mov cx,0
                                 LEA DX, PROMPT_PASSWORD
                                 MOV AH, 9
                                 INT 21H                                 
                                 call VERIFY_PASSWORD
                                          
        RETURN_FROM_PASSWORD_CHECK: RET
        
        screen_clear proc
            mov ah,0
            mov al,3
            int 10h
            
            ret
         screen_clear endp   
 ENDP
        
                                       
    ;CODE ENDp
;END START