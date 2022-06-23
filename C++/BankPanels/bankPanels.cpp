#include <iostream>
#include <string>
#include <vector>

using namespace std;

long long int idCount = 0;
typedef pair<pair<int, double>, int> hist;

class Account {
public:
	long long int id;
	string passwd;
	bool isLocked = false;
	bool isLoggedIn = false;
	Account(string newPasswd) {
		this->id = idCount++;
		this->passwd = newPasswd;
	}
};

//current operations[0]: 0 = deposit, 1 = withdraw, 2 = outgoing transfer, 3 = incoming transfer, 4 = takeLoan, 5 = SplacKredyt

class User : public Account { // ADD locked and logged handling
public:
	double currentMoney = 0;
	double kredyt = 0;
	vector<hist> operationsHistory;
	User(string passwd) : Account(passwd) {
		//pass
	}
	void operationHistoryPushBack(int operationType, double amount, int target){ // -1 if non existent
		hist currentOperation;
		currentOperation.first.first = operationType;
		currentOperation.first.second = amount;
		currentOperation.second = target;
		this->operationsHistory.push_back(currentOperation);
	}
	void deposit(double amount) {
		this->currentMoney += amount;
		operationHistoryPushBack(0, amount, -1);
	}
	void withdraw(double amount) {
		this->currentMoney -= amount;
		operationHistoryPushBack(1, amount, -1);
	}
	void transfer(double amount, User& target) {
		this->currentMoney -= amount;
		operationHistoryPushBack(2, amount, target.id);
		target.receiveTransfer(amount, this->id);
	}
	void receiveTransfer(double amount, int source) {
		this->currentMoney += amount;
		operationHistoryPushBack(3, amount, source);
	}
	void takeLoan(double amount, double interest = 0) {
		this->currentMoney += amount;
		this->kredyt += amount + (amount * interest);
		operationHistoryPushBack(4, amount, -1);
	}
	void SplacKredyt(double amount = -1) {
		if ((amount == -1) || amount > kredyt) {
			amount = this->kredyt;
		}
		if (this->currentMoney < amount) {
			amount = currentMoney;
		}
		currentMoney -= amount;
		kredyt -= amount;
		operationHistoryPushBack(5, amount, -1);
	}
	double* generateSummary() {
		double sumDeposited = 0;
		double sumWithdrawn = 0;
		double sums[2];
		for (auto currentOperation : this->operationsHistory) {
			if (currentOperation.first.first == 0) {
				sumDeposited += currentOperation.first.second;
			}
			else if (currentOperation.first.first == 1) {
				sumWithdrawn += currentOperation.first.second;
			}
		}
		sums[0] = sumDeposited;
		sums[1] = sumWithdrawn;
		return sums;
	}
	vector<hist> checkHistory() {
		return operationsHistory;
	}
};

class Bank {
public:
	vector<User> accounts;
	Bank() {};
	void addAccount(User u) {
		this->accounts.push_back(u);
	}
	long long int findIdIndex(long long int id) {
		for (long long int i = 0; i < this->accounts.size(); ++i) {
			if (accounts[i].id == id) {
				return i;
			}
		}
		return -1;
	}
	void deleteAccount(long long int id) {
		if (this->findIdIndex(id) >= 0)
			accounts.erase(accounts.begin() + this->findIdIndex(id));
		/*for (long long int i = 0; i < this->accounts.size(); ++i) {
			if (accounts[i].id == id) {
				accounts.erase(accounts.begin() + i);
				break;
			}
		}*/
	}
	double countAllUsersMoney() {
		double sum = 0;
		for (auto currentAccount : this->accounts) {
			sum += currentAccount.currentMoney;
		}
		return sum;
	}
};

class Admin : public Account {
public:
	Admin(string passwd) : Account(passwd) {
		//pass
	}
	void lockUserAccount(User u) {
		u.isLocked = true;
	}
	void addAccount(User u, Bank& b) {
		b.addAccount(u);
	}
	void deleteAccount(Bank& b, long long int id) {
		b.deleteAccount(id);
	}
	double countAllBankUsersMoney(Bank b) {
		return b.countAllUsersMoney();
	}
};

int main() {
	string input;
	int userOrAdmin = 0; //1 for user 2 for admin
	int currentId;
	Bank bankObj;
	Admin adm("admin");
	User u("u");
	User u2("u2");
	User* currentUser = nullptr;
	adm.addAccount(u, bankObj);
	adm.addAccount(u2, bankObj);

	cout << "Welcome to our Bank Accessing System!\n"
		<< "Would you like to log in? (Y/N)\n";
	while (cin >> input) {
		if (input == "N" || input == "n") {
			cout << "Goodbye then.";
			return 0;
		}
		if (input == "Y" || input == "y") {
			break;
		}
		cout << "I don't seem to understand your input. Please type Y for yes, or N for no.\n";
	}

	cout << "Do you want to log in as a user or as an administrator? (U/A)\n";
	while (cin >> input) {
		if (input == "U" || input == "u") {
			userOrAdmin = 1;
			break;
		}
		if (input == "A" || input == "a") {
			userOrAdmin = 2;
			break;
		}
		cout << "I don't seem to understand your input. Please type U for user, or A for admin.\n";
	}
	
	cout << "Please provide your unique identifier.\n";
	int inputInt;
	if (userOrAdmin == 1) {
		while (cin >> inputInt && bankObj.findIdIndex(inputInt) == -1) {
			cout << inputInt << "Identifier not found, please provide correct identifier.\n";
		}
		cout << "Please provide your password.\n";
		long long int currentBankId = bankObj.findIdIndex(inputInt);
		string currentPassword = bankObj.accounts[currentBankId].passwd;
		while (cin >> input && input != currentPassword) {
			cout << "Wrong password. Try again.\n";
		}
		currentUser = &(bankObj.accounts[currentBankId]);
	}
	if (userOrAdmin == 2) {//since admin can't add another admin accounts, way to add them is not explicitly stated and I will assume only id 0
		while (cin >> inputInt && inputInt != 0) {
			cout << "Identifier not found, please provide correct identifier.";
		}
		cout << "Please provide your password.\n";
		string currentPassword = adm.passwd;
		while (cin >> input && input != currentPassword) {
			cout << "Wrong password. Try again.\n";
		}
		cout << "Logged in.\n";
	}

	

	if (userOrAdmin == 1) {
		cout << "Your current balance is: " << currentUser->currentMoney
			<< "\nWhat would you like to do?\n Deposit - 1\n withdraw - 2\n transfer - 3\n "
			<< "check operation history - 4\n generate sum of all despoitsand withdraws - 5\n "
			<< "take a loan - 6\n pay off the loan - 7\n log off and quit - 8\n";
		while (cin >> inputInt) {
			switch (inputInt) {
				long long int tempBankId;
				double tempAmount;
				case 1:
					cout << "Please specify how much you'd like to deposit.\n";
					cin >> tempAmount;
					currentUser->deposit(tempAmount); //... there was no verification specified so I'll leave it as it is
					cout << "Your new balance is: " << currentUser->currentMoney << "\n";
					break;
				case 2:
					cout << "Please specify how much you'd like to withdraw.\n";
					cin >> tempAmount;
					currentUser->withdraw(tempAmount); //no debit mechanism
					cout << "Your new balance is: " << currentUser->currentMoney << "\n";
					break;
				case 3:
					cout << "Please specify how much you'd like to transfer.\n";
					cin >> tempAmount;
					cout << "Please specify the id of the person/organisation you'd like to transfer to.\n";
					cin >> inputInt;
					tempBankId = bankObj.findIdIndex(inputInt);
					if (tempBankId == -1) {
						cout << "Invalid identifier.\n";
						break;
					}
					currentUser->transfer(tempAmount, bankObj.accounts[tempBankId]);
					cout << "Your new balance is: " << currentUser->currentMoney << "\n";
					break;
				case 4:

					break;
				case 5:

					break;
				case 6:

					break;
				case 7:

					break;
				case 8:
					cout << "Good bye. We hope you have a nice day";
					return 0;
				default:
					cout << "Unknown number. Please try again.";
					break;
			}
			cout << "What would you like to do next ? \n Deposit - 1\n withdraw - 2\n transfer - 3\n "
				<< "check operation history - 4\n generate sum of all despoitsand withdraws - 5\n "
				<< "take a loan - 6\n pay off the loan - 7\n log off and quit - 8\n";
		}
	}
	if (userOrAdmin == 2) {
		cout << "What would you like to do?\n Lock an account - 1\n add an account - 2\n delete an account - 3\n "
			<< "check how much money there is in a bank - 4\n check all debts issued - 5\n "
			<< "show all debtors - 6\n";
	}

	

	return 0;
}