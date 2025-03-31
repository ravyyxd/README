<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Roblox Executors</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #111;
            color: #eee;
            margin: 0;
            padding: 0;
            overflow-x: hidden; /* Prevent horizontal scroll */
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
        }

        h1 {
            font-size: 2.5em;
            color: #e44d26; /* Red accent color */
            text-align: center;
            margin-bottom: 20px;
        }

        .platform-selector {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .platform-button {
            background-color: #222;
            color: #fff;
            border: 1px solid #e44d26;
            padding: 10px 20px;
            margin: 0 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s, color 0.3s;
        }

        .platform-button:hover {
            background-color: #e44d26;
            color: #111;
        }

        .executor-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .executor-card {
            background-color: #222;
            border: 1px solid #444;
            border-radius: 5px;
            padding: 15px;
            transition: transform 0.3s;
        }

        .executor-card:hover {
            transform: translateY(-5px);
        }

        .executor-title {
            font-size: 1.2em;
            color: #e44d26;
            margin-bottom: 5px;
        }

        .executor-description {
            font-size: 0.9em;
            color: #bbb;
            margin-bottom: 10px;
            height: 60px; /* Set a fixed height */
            overflow: hidden; /* Hide overflow text */
        }

        .executor-download {
            background-color: #e44d26;
            color: #fff;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .executor-download:hover {
            background-color: #bd3c1d;
        }

        .public-script-section {
            margin-top: 30px;
            text-align: center;
        }

        .public-script-button {
            background-color: #444;
            color: #fff;
            border: 1px solid #e44d26;
            padding: 12px 25px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.1em;
            transition: background-color 0.3s, color 0.3s;
        }

        .public-script-button:hover {
            background-color: #e44d26;
            color: #111;
        }

        /* Placeholder styles for demonstration */
        .script-list {
            background-color: #222;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
            text-align: left; /* Align text to the left */
        }

        .script-item {
            border-bottom: 1px solid #444;
            padding: 10px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .script-item:last-child {
            border-bottom: none;
        }

        .script-info {
            flex: 1;
            margin-right: 10px;
        }

        .script-name {
            font-size: 1.1em;
            color: #e44d26;
            margin-bottom: 5px;
        }

        .script-description {
            color: #bbb;
            font-size: 0.9em;
        }

        .script-upload-time {
            color: #888;
            font-size: 0.8em;
        }

        .script-use-button {
            background-color: #e44d26;
            color: #fff;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .script-use-button:hover {
            background-color: #bd3c1d;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Roblox Executors</h1>

        <div class="platform-selector">
            <button class="platform-button">
                <img src="https://logodix.com/logo/1042145.png" alt="Windows" style="width: 20px; vertical-align: middle; margin-right: 5px;">
                Windows
            </button>
            <button class="platform-button">
                <img src="https://www.iconsdb.com/icons/preview/white/mac-os-xxl.png" alt="macOS" style="width: 20px; vertical-align: middle; margin-right: 5px;">
                macOS
            </button>
            <button class="platform-button">
                <img src="https://www.iconsdb.com/icons/preview/white/android-6-xxl.png" alt="Android" style="width: 20px; vertical-align: middle; margin-right: 5px;">
                Android
            </button>
            <button class="platform-button">
                <img src="https://img.icons8.com/ios-filled/50/FFFFFF/ios-logo.png" alt="iOS" style="width: 20px; vertical-align: middle; margin-right: 5px;">
                iOS
            </button>
        </div>

        <div class="executor-list">
            <div class="executor-card">
                <h2 class="executor-title">Codex</h2>
                <p class="executor-description">A powerful executor with advanced features. Supports various scripts and offers a stable experience.</p>
                <button class="executor-download">Download</button>
            </div>

            <div class="executor-card">
                <h2 class="executor-title">Thunder</h2>
                <p class="executor-description">Lightweight executor perfect for low-end devices. Easy to use and compatible with most scripts.</p>
                <button class="executor-download">Download</button>
            </div>

            <!-- More executors here -->
        </div>

        <div class="public-script-section">
            <button class="public-script-button">Public scripts</button>

            <!-- Placeholder for the script list (dynamic content would go here) -->
            <div class="script-list">
                <div class="script-item">
                    <div class="script-info">
                        <div class="script-name">Auto Farm Script</div><onclick="autofarm">
                        <div class="script-description">Automatically farms resources in the game.</div>
                        <div class="script-upload-time">Uploaded: 31/03/2025</div>
                    </div>
                    <button class="script-use-button">Use Script</button>
                </div>

                <div class="script-item">
                    <div class="script-info">
                        <div class="script-name">Teleport Hack</div><oncliick ="teleporthack"></oncliick>
                        <div class="script-description">Teleports the player to any location.</div>
                        <div class="script-upload-time">Uploaded: 31/03/2025</div>
                    </div>
                    <button class="script-use-button">Use Script</button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
