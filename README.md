# ATM-machine-emu8086

**Introduction**
This project is an ATM (Automated Teller Machine) system implemented in 8086 assembly language. It allows users to interact with a simulated ATM, perform basic banking operations like checking balance, depositing money, and withdrawing cash.

**Features**
**User Authentication**: Secure PIN-based login system.
**Check Balance**: Displays the current balance of the user.
**Deposit Money**: Allows users to add money to their account.
**Withdraw Money**: Enables users to withdraw money within their balance limit.
**Exit Option**: Safely terminates the program.

**How It Works**
The user is prompted to enter their PIN.
Upon successful authentication, a menu is displayed with available options.
The user can choose an operation:
View balance
Deposit money
Withdraw money
Exit
The system processes the request and updates the balance accordingly.
The program continues until the user chooses to exit.

**Code Structure**
**Data Segment**: Stores PIN, balance, and messages.
**Code Segment**: Contains the main logic for ATM functions.

**Procedures**:
AuthenticateUser - Verifies user PIN
CheckBalance - Displays the balance
DepositMoney - Adds funds
WithdrawMoney - Deducts funds if sufficient balance is available
ExitProgram - Terminates execution

**Project Contributors**
Saleena Ahuja
Sahil kumar valecha
paras parveen
