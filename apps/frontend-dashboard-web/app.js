const clientGrid = document.querySelector("#clientGrid");
const emptyText = document.querySelector("#emptyText");
const countText = document.querySelector("#countText");
const connectionText = document.querySelector("#connectionText");
const refreshButton = document.querySelector("#refreshButton");
const loginView = document.querySelector("#loginView");
const appView = document.querySelector("#appView");
const loginForm = document.querySelector("#loginForm");
const locationInput = document.querySelector("#locationInput");
const passwordInput = document.querySelector("#passwordInput");
const loginError = document.querySelector("#loginError");
const logoutButton = document.querySelector("#logoutButton");
const notifications = document.querySelector("#notifications");
const dashboardPage = document.querySelector("#dashboardPage");
const clientHeading = document.querySelector("#clientHeading");
const settingsPage = document.querySelector("#settingsPage");
const navTabs = [...document.querySelectorAll(".nav-tab")];
const showLastSeenInput = document.querySelector("#showLastSeenInput");
const confirmPowerInput = document.querySelector("#confirmPowerInput");
const idleThresholdInput = document.querySelector("#idleThresholdInput");
const saveIdleThresholdButton = document.querySelector("#saveIdleThresholdButton");

let clients = [];
let dashboardSocket;
let authenticated = false;
let currentLocation = "";
const screenImages = new Map();
const expandedFeatures = new Map();
const knownActivityStatuses = new Map();
const clientNameCollator = new Intl.Collator(undefined, {
  numeric: true,
  sensitivity: "base",
});
const preferences = {
  showLastSeen: localStorage.getItem("showLastSeen") !== "false",
  confirmPowerActions: localStorage.getItem("confirmPowerActions") !== "false",
};

const commandLabels = {
  shutdown: "Shutdown",
  restart: "Restart",
  close_application: "Close application",
  start_screen_monitoring: "Start screen monitoring",
  stop_screen_monitoring: "Stop screen monitoring",
};

function formatTime(value) {
  return new Date(value).toLocaleTimeString([], {
    hour: "numeric",
    minute: "2-digit",
    second: "2-digit",
    hour12: true,
  });
}

function getLastActiveTime(client) {
  const lastSeenMilliseconds = new Date(client.last_seen_at).getTime();
  const idleMilliseconds = Number(client.idle_seconds ?? 0) * 1000;
  return new Date(lastSeenMilliseconds - idleMilliseconds);
}

function processActivityTransitions(updatedClients) {
  const connectedPcNames = new Set();
  for (const client of updatedClients) {
    connectedPcNames.add(client.pc_name);
    const previousStatus = knownActivityStatuses.get(client.pc_name);
    if (previousStatus === "active" && client.activity_status === "idle") {
      const message = {
        type: "client_idle",
        pc_name: client.pc_name,
      };
      window.chrome?.webview?.postMessage(message);
      window.PisonetAndroid?.postMessage(JSON.stringify(message));
    }
    knownActivityStatuses.set(client.pc_name, client.activity_status);
  }

  for (const pcName of knownActivityStatuses.keys()) {
    if (!connectedPcNames.has(pcName)) {
      knownActivityStatuses.delete(pcName);
    }
  }
}

function setConnectionState(text, isOnline) {
  connectionText.textContent = text;
  connectionText.dataset.online = String(isOnline);
}

function setCurrentLocation(location) {
  currentLocation = location || "";
  clientHeading.textContent = currentLocation
    ? `${currentLocation} Client PCs`
    : "Client PCs";
}

function showNotification(message, success = true) {
  const notification = document.createElement("div");
  notification.className = `notification ${success ? "success" : "error"}`;
  notification.textContent = message;
  notifications.append(notification);
  window.setTimeout(() => notification.remove(), 5000);
}

function isFeatureExpanded(pcName, feature) {
  return expandedFeatures.get(pcName)?.has(feature) ?? false;
}

function setFeatureExpanded(pcName, feature, expanded) {
  const features = expandedFeatures.get(pcName) ?? new Set();
  if (expanded) {
    features.add(feature);
  } else {
    features.delete(feature);
  }

  if (features.size > 0) {
    expandedFeatures.set(pcName, features);
  } else {
    expandedFeatures.delete(pcName);
  }
}

function showPage(pageName) {
  dashboardPage.hidden = pageName !== "dashboard";
  settingsPage.hidden = pageName !== "settings";
  for (const tab of navTabs) {
    const selected = tab.dataset.page === pageName;
    tab.classList.toggle("active", selected);
    tab.setAttribute("aria-selected", String(selected));
  }
}

function showLogin() {
  authenticated = false;
  setCurrentLocation("");
  clients = [];
  if (dashboardSocket) {
    dashboardSocket.close();
  }

  if (new URLSearchParams(window.location.search).get("android") === "1") {
    window.location.href = "pisonet-manager://authentication-required";
    return;
  }

  if (new URLSearchParams(window.location.search).get("desktop") === "1" && window.chrome?.webview) {
    loginView.hidden = true;
    appView.hidden = true;
    window.chrome.webview.postMessage({ type: "authentication_required" });
    return;
  }

  loginView.hidden = false;
  appView.hidden = true;
  passwordInput.focus();
}

async function showDashboard() {
  authenticated = true;
  loginView.hidden = true;
  appView.hidden = false;
  await Promise.all([fetchClients(), fetchServerSettings()]);
  connectDashboardSocket();
}

function renderClients() {
  clientGrid.innerHTML = "";
  countText.textContent = `${clients.length} online`;
  emptyText.hidden = clients.length > 0;

  const sortedClients = [...clients].sort((left, right) =>
    clientNameCollator.compare(left.pc_name, right.pc_name),
  );

  for (const client of sortedClients) {
    if (!client.screen_monitoring) {
      screenImages.delete(client.pc_name);
    }

    const card = document.createElement("article");
    card.className = "client-card";

    const screenExpanded = isFeatureExpanded(client.pc_name, "screen");
    const applicationsExpanded = isFeatureExpanded(client.pc_name, "applications");

    const clientHeader = document.createElement("div");
    clientHeader.className = "client-header";

    const clientIdentity = document.createElement("div");
    clientIdentity.className = "client-identity";

    const title = document.createElement("h3");
    title.textContent = client.pc_name;

    const status = document.createElement("span");
    const activityStatus = client.activity_status === "idle" ? "idle" : "active";
    status.className = `status ${activityStatus}`;
    status.textContent = activityStatus === "idle" ? "Idle" : "Active";

    const meta = document.createElement("p");
    meta.className = "meta";
    meta.textContent = `Last seen ${formatTime(client.last_seen_at)}`;
    meta.hidden = !preferences.showLastSeen;

    const lastActive = document.createElement("p");
    lastActive.className = "meta";
    lastActive.textContent = `Last active ${formatTime(getLastActiveTime(client))}`;

    clientIdentity.append(title, status, meta, lastActive);

    const viewScreenButton = document.createElement("button");
    viewScreenButton.className = "secondary client-action";
    viewScreenButton.type = "button";
    viewScreenButton.textContent = screenExpanded ? "Hide Screen" : "View Screen";
    viewScreenButton.setAttribute("aria-expanded", String(screenExpanded));
    viewScreenButton.addEventListener("click", async () => {
      const shouldExpand = !isFeatureExpanded(client.pc_name, "screen");
      setFeatureExpanded(client.pc_name, "screen", shouldExpand);
      renderClients();
      if (shouldExpand && !client.screen_monitoring) {
        await screenCommand(client.pc_name, "start");
      } else if (!shouldExpand) {
        await screenCommand(client.pc_name, "stop");
      }
    });

    const viewApplicationsButton = document.createElement("button");
    viewApplicationsButton.className = "secondary client-action";
    viewApplicationsButton.type = "button";
    viewApplicationsButton.textContent = applicationsExpanded
      ? "Hide Apps"
      : "View Apps";
    viewApplicationsButton.setAttribute("aria-expanded", String(applicationsExpanded));
    viewApplicationsButton.addEventListener("click", () => {
      setFeatureExpanded(client.pc_name, "applications", !applicationsExpanded);
      renderClients();
    });

    const screenSection = document.createElement("section");
    screenSection.className = "screen-section";
    screenSection.hidden = !screenExpanded;

    const screenHeader = document.createElement("div");
    screenHeader.className = "screen-header";

    const screenTitle = document.createElement("h4");
    screenTitle.textContent = "Screen preview";

    screenHeader.append(screenTitle);
    screenSection.append(screenHeader);

    const currentScreen = screenImages.get(client.pc_name);
    if (currentScreen && client.screen_monitoring) {
      const screenImage = document.createElement("img");
      screenImage.className = "screen-image";
      screenImage.dataset.screenPc = client.pc_name;
      screenImage.src = currentScreen;
      screenImage.alt = `Current screen of ${client.pc_name}`;
      screenSection.append(screenImage);
    } else {
      const waitingText = document.createElement("p");
      waitingText.className = "screen-waiting";
      waitingText.textContent = client.screen_monitoring
        ? "Waiting for preview..."
        : "Starting preview...";
      screenSection.append(waitingText);
    }

    const activeSection = document.createElement("div");
    activeSection.className = "active-app";

    const activeLabel = document.createElement("span");
    activeLabel.textContent = "Active application";

    const activeValue = document.createElement("strong");
    activeValue.textContent = client.active_application?.process_name ?? "None";
    activeValue.title = client.active_application?.window_title ?? "";

    activeSection.append(activeLabel, activeValue);

    const applicationsSection = document.createElement("div");
    applicationsSection.className = "applications";

    const applicationsTitle = document.createElement("h4");
    applicationsTitle.textContent = `Open applications (${client.applications.length})`;
    applicationsSection.append(applicationsTitle);

    const applicationsList = document.createElement("div");
    applicationsList.className = "application-list";

    for (const application of client.applications) {
      const applicationRow = document.createElement("div");
      applicationRow.className = "application-row";

      const applicationDetails = document.createElement("div");
      const applicationName = document.createElement("strong");
      const applicationTitle = document.createElement("span");
      applicationName.textContent = application.process_name;
      applicationTitle.textContent = application.window_title;
      applicationTitle.title = application.window_title;
      applicationDetails.append(applicationName, applicationTitle);

      const closeButton = document.createElement("button");
      closeButton.className = "small danger-outline";
      closeButton.type = "button";
      closeButton.textContent = "Close";
      closeButton.addEventListener("click", () => closeApplication(client.pc_name, application));

      applicationRow.append(applicationDetails, closeButton);
      applicationsList.append(applicationRow);
    }

    if (client.applications.length === 0) {
      const noApplications = document.createElement("p");
      noApplications.className = "meta";
      noApplications.textContent = "No visible applications";
      applicationsList.append(noApplications);
    }

    applicationsSection.append(applicationsList);

    const applicationsDetails = document.createElement("section");
    applicationsDetails.className = "application-details";
    applicationsDetails.hidden = !applicationsExpanded;
    applicationsDetails.append(activeSection, applicationsSection);

    const restartButton = document.createElement("button");
    restartButton.className = "secondary client-action";
    restartButton.type = "button";
    restartButton.textContent = "Restart";
    restartButton.addEventListener("click", () => powerCommand(client.pc_name, "restart"));

    const shutdownButton = document.createElement("button");
    shutdownButton.className = activityStatus === "idle"
      ? "danger client-action"
      : "secondary client-action";
    shutdownButton.type = "button";
    shutdownButton.textContent = "Shutdown";
    shutdownButton.addEventListener("click", () => powerCommand(client.pc_name, "shutdown"));

    const clientActions = document.createElement("div");
    clientActions.className = "client-actions";
    clientActions.append(
      shutdownButton,
      restartButton,
      viewScreenButton,
      viewApplicationsButton,
    );

    clientHeader.append(clientIdentity, clientActions);
    card.append(clientHeader, screenSection, applicationsDetails);
    clientGrid.append(card);
  }
}

async function fetchClients() {
  const response = await fetch("/api/clients");
  if (response.status === 401) {
    showLogin();
    return;
  }
  const updatedClients = await response.json();
  processActivityTransitions(updatedClients);
  clients = updatedClients;
  renderClients();
}

async function fetchServerSettings() {
  const response = await fetch("/api/settings");
  if (response.status === 401) {
    showLogin();
    return;
  }
  if (!response.ok) {
    showNotification("Unable to load server settings.", false);
    return;
  }

  const serverSettings = await response.json();
  idleThresholdInput.value = serverSettings.idle_threshold_minutes;
}

async function saveIdleThreshold() {
  const idleThresholdMinutes = Number(idleThresholdInput.value);
  if (!Number.isInteger(idleThresholdMinutes) || idleThresholdMinutes < 1 || idleThresholdMinutes > 1440) {
    showNotification("Idle threshold must be between 1 and 1440 minutes.", false);
    idleThresholdInput.focus();
    return;
  }

  const saved = await request("/api/settings", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ idle_threshold_minutes: idleThresholdMinutes }),
  });
  if (saved) {
    showNotification("Idle threshold updated.");
  }
}

async function request(path, options = {}) {
  const response = await fetch(path, options);
  if (!response.ok) {
    if (response.status === 401) {
      showLogin();
      return false;
    }
    const error = await response.json();
    showNotification(error.detail ?? "Request failed", false);
    return false;
  }

  const result = await response.json();
  const isScreenCommand = ["start_screen_monitoring", "stop_screen_monitoring"]
    .includes(result.command);
  if (result.command_id && !isScreenCommand) {
    showNotification(`${commandLabels[result.command] ?? "Command"} sent to ${result.pc_name}.`);
  }
  return true;
}

async function powerCommand(pcName, command) {
  const confirmed = !preferences.confirmPowerActions || window.confirm(
    `${command === "restart" ? "Restart" : "Shutdown"} ${pcName}?`,
  );
  if (!confirmed) {
    return;
  }

  await request(`/api/clients/${encodeURIComponent(pcName)}/${command}`, {
    method: "POST",
  });
}

async function closeApplication(pcName, application) {
  const confirmed = window.confirm(`Close ${application.process_name} on ${pcName}?`);
  if (!confirmed) {
    return;
  }

  await request(
    `/api/clients/${encodeURIComponent(pcName)}/applications/${application.pid}/close`,
    { method: "POST" },
  );
}

async function screenCommand(pcName, action) {
  await request(`/api/clients/${encodeURIComponent(pcName)}/screen/${action}`, {
    method: "POST",
  });
}

function connectDashboardSocket() {
  const protocol = window.location.protocol === "https:" ? "wss" : "ws";
  dashboardSocket = new WebSocket(`${protocol}://${window.location.host}/ws/dashboard`);

  dashboardSocket.addEventListener("open", () => {
    setConnectionState("Live connection active", true);
  });

  dashboardSocket.addEventListener("message", (event) => {
    const message = JSON.parse(event.data);
    if (message.type === "clients") {
      processActivityTransitions(message.clients);
      clients = message.clients;
      renderClients();
    } else if (message.type === "command_result") {
      const label = commandLabels[message.command] ?? "Command";
      if (message.success && message.command === "start_screen_monitoring") {
        showNotification("Recording");
      } else if (message.success && message.command === "stop_screen_monitoring") {
        showNotification("Recording stopped");
      } else {
        showNotification(`${label} on ${message.pc_name}: ${message.message}`, message.success);
      }
      if (message.success && message.command === "stop_screen_monitoring") {
        screenImages.delete(message.pc_name);
      }
    } else if (message.type === "screenshot") {
      screenImages.set(message.pc_name, message.image_data);
      const screenImage = [...document.querySelectorAll("[data-screen-pc]")]
        .find((image) => image.dataset.screenPc === message.pc_name);
      if (screenImage) {
        screenImage.src = message.image_data;
      } else {
        renderClients();
      }
    }
  });

  dashboardSocket.addEventListener("close", () => {
    setConnectionState("Disconnected. Reconnecting...", false);
    if (authenticated) {
      window.setTimeout(connectDashboardSocket, 2000);
    }
  });
}

refreshButton.addEventListener("click", fetchClients);
saveIdleThresholdButton.addEventListener("click", saveIdleThreshold);
idleThresholdInput.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    saveIdleThresholdButton.click();
  }
});
for (const tab of navTabs) {
  tab.addEventListener("click", () => showPage(tab.dataset.page));
}

showLastSeenInput.checked = preferences.showLastSeen;
showLastSeenInput.addEventListener("change", () => {
  preferences.showLastSeen = showLastSeenInput.checked;
  localStorage.setItem("showLastSeen", String(preferences.showLastSeen));
  renderClients();
});

confirmPowerInput.checked = preferences.confirmPowerActions;
confirmPowerInput.addEventListener("change", () => {
  preferences.confirmPowerActions = confirmPowerInput.checked;
  localStorage.setItem("confirmPowerActions", String(preferences.confirmPowerActions));
});

logoutButton.addEventListener("click", async () => {
  await fetch("/api/logout", { method: "POST" });
  showLogin();
});

loginForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  loginError.hidden = true;

  const response = await fetch("/api/login", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      location: locationInput.value,
      password: passwordInput.value,
    }),
  });

  if (!response.ok) {
    const error = await response.json();
    loginError.textContent = error.detail ?? "Unable to sign in";
    loginError.hidden = false;
    passwordInput.select();
    return;
  }

  const result = await response.json();
  setCurrentLocation(result.location);
  passwordInput.value = "";
  await showDashboard();
});

async function initialize() {
  const response = await fetch("/api/me");
  if (response.ok) {
    const result = await response.json();
    setCurrentLocation(result.location);
    await showDashboard();
  } else {
    showLogin();
  }
}

initialize().catch(() => showLogin());
