class FamilyConnect {
    constructor() {
        this.familyMembers = [];
        this.connectionStatus = 'disconnected';
        this.init();
    }

    init() {
        this.bindEvents();
        this.loadStoredConnections();
    }

    bindEvents() {
        const connectBtn = document.getElementById('connect-btn');
        const familyCodeInput = document.getElementById('family-code');

        connectBtn.addEventListener('click', () => this.connectToFamily());
        familyCodeInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.connectToFamily();
            }
        });
    }

    connectToFamily() {
        const familyCode = document.getElementById('family-code').value.trim();
        
        if (!familyCode) {
            alert('Please enter a family code');
            return;
        }

        // Simulate connection process
        this.showConnecting();
        
        setTimeout(() => {
            this.establishConnection(familyCode);
        }, 2000);
    }

    showConnecting() {
        const connectBtn = document.getElementById('connect-btn');
        connectBtn.textContent = 'Connecting...';
        connectBtn.disabled = true;
    }

    establishConnection(familyCode) {
        // Mock family data - in real app this would come from API
        const mockFamilyData = {
            'BAG001': [
                { name: 'Rajesh Bagvanth', status: 'online', relation: 'Father' },
                { name: 'Sunita Bagvanth', status: 'online', relation: 'Mother' },
                { name: 'Arjun Bagvanth', status: 'offline', relation: 'Brother' },
                { name: 'Priya Bagvanth', status: 'online', relation: 'Sister' }
            ]
        };

        const connectBtn = document.getElementById('connect-btn');
        
        if (mockFamilyData[familyCode]) {
            this.familyMembers = mockFamilyData[familyCode];
            this.connectionStatus = 'connected';
            this.renderFamilyMembers();
            this.saveConnection(familyCode);
            
            connectBtn.textContent = 'Connected';
            connectBtn.style.backgroundColor = '#2ecc71';
        } else {
            alert('Invalid family code. Please check and try again.');
            connectBtn.textContent = 'Connect';
            connectBtn.disabled = false;
        }
    }

    renderFamilyMembers() {
        const membersContainer = document.getElementById('family-members');
        
        if (this.familyMembers.length === 0) {
            membersContainer.innerHTML = '<p>No family members found.</p>';
            return;
        }

        const membersHTML = this.familyMembers.map(member => `
            <div class="family-member">
                <strong>${member.name}</strong> - ${member.relation}
                <span class="member-status status-${member.status}">${member.status}</span>
            </div>
        `).join('');

        membersContainer.innerHTML = `
            <h3>Connected Family Members (${this.familyMembers.length})</h3>
            ${membersHTML}
        `;
    }

    saveConnection(familyCode) {
        localStorage.setItem('bagvanth-family-code', familyCode);
        localStorage.setItem('bagvanth-connection-time', new Date().toISOString());
    }

    loadStoredConnections() {
        const storedCode = localStorage.getItem('bagvanth-family-code');
        if (storedCode) {
            document.getElementById('family-code').value = storedCode;
        }
    }

    disconnect() {
        this.familyMembers = [];
        this.connectionStatus = 'disconnected';
        localStorage.removeItem('bagvanth-family-code');
        
        const connectBtn = document.getElementById('connect-btn');
        connectBtn.textContent = 'Connect';
        connectBtn.disabled = false;
        connectBtn.style.backgroundColor = '#3498db';
        
        document.getElementById('family-members').innerHTML = '';
    }
}

// Initialize the family connect system when page loads
document.addEventListener('DOMContentLoaded', () => {
    window.familyConnect = new FamilyConnect();
});
