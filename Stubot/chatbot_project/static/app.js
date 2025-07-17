// JavaScript code to handle active class on navigation links
document.addEventListener('DOMContentLoaded', function () {
    var navLinks = document.querySelectorAll('nav a');
    var isUserActive = false;
    var isFirstUserInput = true; // Variable to track the first user input
    var userEmail = null;
    var userPhoneNumber = null;
    var chatbox = document.getElementById('chatbox');
    var chatboxContent = document.getElementById('chatbox-content');
    var chatboxInput = document.querySelector('.chatbox-input');
    var chatboxSendBtn = document.querySelector('.chatbox-send-btn');


    navLinks.forEach(function (link) {
        link.addEventListener('click', function () {
            // Remove 'active' class from all links
            navLinks.forEach(function (navLink) {
                navLink.classList.remove('active');
            });

            // Add 'active' class to the clicked link
            link.classList.add('active');
        });
    });

    // Function to toggle chatbox and send message
    function toggleChatbox() {
        if (chatbox.style.display === 'none' || chatbox.style.display === '') {
            chatbox.style.display = 'block';
            chatbox.style.opacity = 1;
            setTimeout(() => {
                chatboxContent.style.opacity = 1;
            }, 70);
        } else {
            chatbox.style.display = 'none';
            chatbox.style.opacity = 0;
            chatboxContent.style.opacity = 0;
        }
    }

    // Attach the function to the chat icon
    document.querySelector('.chat-icon').addEventListener('click', toggleChatbox);

    // Prevent the chatbox from closing when clicking on the text input
    chatboxInput.addEventListener('click', function (event) {
        event.stopPropagation();
    });

    // Prevent the chatbox from closing when clicking on the send button
    chatboxSendBtn.addEventListener('click', function (event) {
        event.stopPropagation();
        sendMessage();
    });

    // Add this function to handle the AJAX request
    function sendUserInputToServer(userMessage) {
        // You can customize the AJAX request based on your needs
        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'message');
        xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');

        // Set up the data to be sent in JSON format
        var requestData = {
            user_message: userMessage,
        };

        // Convert the data to JSON string
        var jsonData = JSON.stringify(requestData);

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    // Handle the response from the server
                    var response = JSON.parse(xhr.responseText);
                    // Display StuBot's response in the chatbox
                    var chatboxContent = document.getElementById('chatbox-content');
                    // Reply from StuBot
                    setTimeout(function () {
                        // Append the bot's response to the chatbox content   
                        chatboxContent.innerHTML += '<p><strong>StuBot:</strong> ' + response.message + '</p>';
                        // Scroll to the bottom of the chatbox to show the latest messages
                        chatboxContent.scrollTop = chatboxContent.scrollHeight;
                    }, 1000); // Set the timeout duration in milliseconds (e.g., 1000 ms = 1 second)
                } else {
                    console.error('Error:', xhr.status);
                }
            }
        };

        // Send the AJAX request
        xhr.send(jsonData);
    }

    // Function to handle the AJAX request to send email and phone number
    function sendUserEmailAndNumberToServer() {
        // You don't need to pass any arguments since userEmail and userPhoneNumber are global
        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'userInfo');
        xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
    
        // Set up the data to be sent in JSON format
        var requestData = {
            userEmail: userEmail,
            userPhoneNumber: userPhoneNumber,
        };
    
        // Convert the data to JSON string
        var jsonData = JSON.stringify(requestData);
    
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    // Handle the response from the server
                    var response = JSON.parse(xhr.responseText);
                    // Display StuBot's response in the chatbox
                    var chatboxContent = document.getElementById('chatbox-content');
                    // Reply from StuBot
                    setTimeout(function () {
                        // Append the bot's response to the chatbox content   
                        chatboxContent.innerHTML += '<p><strong>StuBot:</strong> ' + response.message + '</p>';
                        // Scroll to the bottom of the chatbox to show the latest messages
                        chatboxContent.scrollTop = chatboxContent.scrollHeight;
                    }, 1300); // Set the timeout duration in milliseconds (e.g., 1000 ms = 1 second)
                } else {
                    console.error('Error:', xhr.status);
                }
            }
        };
    
        // Send the AJAX request
        xhr.send(jsonData);
    }

    function inputEmail(userMessage) {
        if (!isValidEmail(userMessage)) {
            // Reply from StuBot
            setTimeout(function () {
                // Append the bot's response to the chatbox content   
                // Display an error message and do not send to the server
                chatboxContent.innerHTML += '<p><strong>StuBot:</strong> Please enter a valid email address.</p>';
                return;
                // Scroll to the bottom of the chatbox to show the latest messages
                chatboxContent.scrollTop = chatboxContent.scrollHeight;
            }, 1300); // Set the timeout duration in milliseconds (e.g., 1000 ms = 1 second)
        }
        else {
            // Save email and request phone number
            userEmail = userMessage;
            setTimeout(function () {
                // Append the bot's response to the chatbox content   
                chatboxContent.innerHTML += '<p><strong>StuBot:</strong> Please enter your phone number</p>';
                // Scroll to the bottom of the chatbox to show the latest messages
                chatboxContent.scrollTop = chatboxContent.scrollHeight;
            }, 1300); // Set the timeout duration in milliseconds (e.g., 1000 ms = 1 second)
        }
    }
    
    function inputPhoneNumber(userMessage) {
        if (!isValidPhoneNumber(userMessage)) {
            // Reply from StuBot
            setTimeout(function () {
                // Append the bot's response to the chatbox content
                // Display an error message and do not send to the server
                chatboxContent.innerHTML += '<p><strong>StuBot:</strong> Please enter a valid phone number.</p>';
                return;
                // Scroll to the bottom of the chatbox to show the latest messages
                chatboxContent.scrollTop = chatboxContent.scrollHeight;
            }, 1300); // Set the timeout duration in milliseconds (e.g., 1000 ms = 1 second)
        }
        else {
            // Save phone number and send data to backend
            userPhoneNumber = userMessage;
            // Call the AJAX function to send user email and phone number to the server
            sendUserEmailAndNumberToServer();
        }
    }


    // Function to send user message
    function sendMessage() {
        var inputElement = document.querySelector('.chatbox-input');
        var userMessage = inputElement.value.trim(); // Trim the message to remove leading/trailing spaces
    
        // Clear the input field after sending the message
        inputElement.value = '';
    
        // Do not proceed if the user input is empty
        if (!userMessage) {
            return;
        }
    
        // Update the chatbox content with user's message
        var chatboxContent = document.getElementById('chatbox-content');
        setTimeout(() => {
            chatboxContent.innerHTML += '<p><strong>You:</strong> ' + userMessage + '</p>';
        }, 100);

        // Check if it's the user's first input
        if (isFirstUserInput) {
            if (userEmail == null) {
                inputEmail(userMessage)
            }
            else {
                inputPhoneNumber(userMessage)
            }
        }
        else {
            // Call the AJAX function to send user input to the server
            sendUserInputToServer(userMessage);
        }
    }
    
    // Function to check if the input is a valid email address
    function isValidEmail(userMessage) {
        // Regular expression for validating an Email
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(userMessage);
    }

    // Function to check if the input is a valid phone number
    function isValidPhoneNumber(userMessage) {
        // Regular expression for validating a phone number
        // This example assumes a basic format (e.g., +1234567890 or 123-456-7890)
        var phoneRegex = /^(\+\d{1,})?[-.\s]?\(?\d{1,}\)?[-.\s]?\d{1,}[-.\s]?\d{1,}[-.\s]?\d{1,}$/;
        return phoneRegex.test(userMessage);
    }

    // Get the current year
    var currentYear = new Date().getFullYear();
    // Set the year in the HTML element
    document.getElementById("year").innerHTML = currentYear;
    
    // Attach the functions to the corresponding elements
    document.getElementById('chatbox').addEventListener('click', toggleChatbox);
    document.querySelector('.chatbox-send-btn').addEventListener('click', sendMessage);
});
