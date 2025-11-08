document.addEventListener('DOMContentLoaded', function() {
    const connectBtn = document.getElementById('connect-btn');
    const familyCodeInput = document.getElementById('family-code');
    const familyMembersDiv = document.getElementById('family-members');

    // Sample family data
    const familyData = {
        'BAG2024': [
            { name: 'Rajesh Bagvanth', role: 'Admin', status: 'online' },
            { name: 'Priya Bagvanth', role: 'Member', status: 'online' },
            { name: 'Arjun Bagvanth', role: 'Member', status: 'offline' },
            { name: 'Meera Bagvanth', role: 'Member', status: 'online' }
        ],
        'BAG2025': [
            { name: 'Suresh Bagvanth', role: 'Admin', status: 'online' },
            { name: 'Lakshmi Bagvanth', role: 'Member', status: 'online' },
            { name: 'Kiran Bagvanth', role: 'Member', status: 'offline' }
        ]
    };

    if (connectBtn) {
        connectBtn.addEventListener('click', function() {
            const code = familyCodeInput.value.trim().toUpperCase();
            
            if (!code) {
                alert('Please enter a family code');
                return;
            }

            if (familyData[code]) {
                displayFamilyMembers(code, familyData[code]);
            } else {
                familyMembersDiv.innerHTML = `
                    <h3>Family Code Not Found</h3>
                    <p style="color: #dc3545; text-align: center;">
                        The family code "${code}" was not found. Please check your code and try again.
                    </p>
                    <p style="text-align: center; margin-top: 1rem;">
                        Try: BAG2024 or BAG2025
                    </p>
                `;
            }
        });
    }

    // Allow Enter key to connect
    if (familyCodeInput) {
        familyCodeInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                connectBtn.click();
            }
        });
    }

    function displayFamilyMembers(code, members) {
        let membersHtml = `
            <h3>Family Members for Code: ${code}</h3>
            <div style="margin-top: 1rem;">
        `;

        members.forEach(member => {
            const statusColor = member.status === 'online' ? '#28a745' : '#6c757d';
            const statusIcon = member.status === 'online' ? '🟢' : '⚫';
            
            membersHtml += `
                <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; margin: 5px 0; background: white; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
                    <div>
                        <span style="font-weight: bold;">👤 ${member.name}</span>
                        <span style="margin-left: 10px; color: #666; font-size: 14px;">(${member.role})</span>
                    </div>
                    <div style="color: ${statusColor};">
                        ${statusIcon} ${member.status}
                    </div>
                </div>
            `;
        });

        membersHtml += '</div>';
        familyMembersDiv.innerHTML = membersHtml;
    }

    // Initialize with default message
    if (familyMembersDiv) {
        familyMembersDiv.innerHTML = `
            <h3>Family Members</h3>
            <p style="text-align: center; color: #666;">Enter your family code to see connected members</p>
            <p style="text-align: center; margin-top: 1rem; font-size: 14px; color: #888;">
                Demo codes: BAG2024, BAG2025
            </p>
        `;
    }
});
