// ========== CHATBOT v3 — Working Version ==========
(function() {
    'use strict';

    // Chatbot initialize karne wala function
    function initChatbot() {
        // Agar already button hai toh skip karo
        if (document.getElementById('chatbotBtn')) {
            console.log('Chatbot already initialized');
            return;
        }

        // Check karo student page hai ya nahi
        var isStudentPage = document.querySelector('a[href="MyApplicationsServlet"]') !== null;
        if (!isStudentPage) {
            console.log('Not a student page, skipping chatbot');
            return;
        }

        console.log('Initializing chatbot...');

        // Chat button create karo
        var chatBtn = document.createElement('button');
        chatBtn.id = 'chatbotBtn';
        chatBtn.className = 'chatbot-btn';
        chatBtn.innerHTML = '<i class="fas fa-comments"></i>';
        chatBtn.title = 'Ask Chatbot';

        // Chat window create karo
        var chatWin = document.createElement('div');
        chatWin.id = 'chatbotWindow';
        chatWin.className = 'chatbot-window';
        chatWin.innerHTML = 
            '<div class="chatbot-header">' +
                '<div class="chatbot-header-left">' +
                    '<div class="chatbot-avatar"><i class="fas fa-robot"></i></div>' +
                    '<div>' +
                        '<div class="chatbot-title">Placement Assistant</div>' +
                        '<div class="chatbot-status">Online</div>' +
                    '</div>' +
                '</div>' +
                '<button class="chatbot-close" id="chatbotClose">' +
                    '<i class="fas fa-times"></i>' +
                '</button>' +
            '</div>' +
            '<div class="chatbot-messages" id="chatbotMessages">' +
                '<div class="chat-msg bot">' +
                    '<div class="chat-bubble">Hi! I am your placement assistant. Ask me anything about jobs, applications, resume, events, or interviews!</div>' +
                '</div>' +
            '</div>' +
            '<div class="chatbot-quick">' +
                '<button type="button" data-ask="How to apply for a job?">How to apply?</button>' +
                '<button type="button" data-ask="My applications status">My Applications</button>' +
                '<button type="button" data-ask="Available jobs">Jobs</button>' +
                '<button type="button" data-ask="Upcoming events">Events</button>' +
            '</div>' +
            '<div class="chatbot-input">' +
                '<input type="text" id="chatbotInput" placeholder="Type your question...">' +
                '<button type="button" id="chatbotSend"><i class="fas fa-paper-plane"></i></button>' +
            '</div>';

        // Body me add karo
        document.body.appendChild(chatBtn);
        document.body.appendChild(chatWin);

        // Toggle chat on button click
        chatBtn.addEventListener('click', function() {
            chatWin.classList.toggle('open');
            if (chatWin.classList.contains('open')) {
                setTimeout(function() {
                    var inp = document.getElementById('chatbotInput');
                    if (inp) inp.focus();
                }, 100);
            }
        });

        // Close button
        var closeBtn = document.getElementById('chatbotClose');
        if (closeBtn) {
            closeBtn.addEventListener('click', function() {
                chatWin.classList.remove('open');
            });
        }

        // Send button
        var sendBtn = document.getElementById('chatbotSend');
        if (sendBtn) {
            sendBtn.addEventListener('click', sendMessage);
        }

        // Enter key
        var inputField = document.getElementById('chatbotInput');
        if (inputField) {
            inputField.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') sendMessage();
            });
        }

        // Quick action buttons
        var quickBtns = chatWin.querySelectorAll('.chatbot-quick button');
        for (var i = 0; i < quickBtns.length; i++) {
            quickBtns[i].addEventListener('click', function() {
                var text = this.getAttribute('data-ask');
                var inp = document.getElementById('chatbotInput');
                if (inp) {
                    inp.value = text;
                    sendMessage();
                }
            });
        }

        console.log('✅ Chatbot initialized successfully');
    }

    // DOM ready hone ka wait karo
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initChatbot);
    } else {
        // DOM already ready hai
        initChatbot();
    }

    // Fallback — 500ms baad dobara try karo (agar pehli baar fail ho)
    setTimeout(initChatbot, 500);

})();

// ========== SEND MESSAGE FUNCTION ==========
function sendMessage() {
    var input = document.getElementById('chatbotInput');
    if (!input) return;
    
    var message = input.value.trim();
    if (!message) return;

    var messages = document.getElementById('chatbotMessages');
    if (!messages) return;

    // User ka message add karo
    var userMsgHtml = '<div class="chat-msg user"><div class="chat-bubble">' + escapeHtml(message) + '</div></div>';
    messages.innerHTML += userMsgHtml;

    input.value = '';
    messages.scrollTop = messages.scrollHeight;

    // Typing indicator
    var typingId = 'typing-' + Date.now();
    var typingHtml = '<div class="chat-msg bot" id="' + typingId + '"><div class="chat-bubble typing"><span></span><span></span><span></span></div></div>';
    messages.innerHTML += typingHtml;
    messages.scrollTop = messages.scrollHeight;

    // Server ko bhejo
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'ChatBotServlet', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            // Typing indicator remove karo
            var typingEl = document.getElementById(typingId);
            if (typingEl) typingEl.remove();

            var reply = 'Sorry, something went wrong.';
            
            if (xhr.status === 200) {
                try {
                    var data = JSON.parse(xhr.responseText);
                    if (data && data.reply) {
                        reply = data.reply;
                    }
                } catch (e) {
                    reply = 'Error parsing response.';
                    console.error('JSON parse error:', e);
                }
            } else {
                reply = 'Server error: ' + xhr.status;
            }

            // Bot reply add karo
            var botMsgHtml = '<div class="chat-msg bot"><div class="chat-bubble">' + 
                escapeHtml(reply).replace(/\n/g, '<br>') + 
                '</div></div>';
            messages.innerHTML += botMsgHtml;
            messages.scrollTop = messages.scrollHeight;
        }
    };
    
    xhr.send('message=' + encodeURIComponent(message));
}

// ========== ESCAPE HTML ==========
function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}