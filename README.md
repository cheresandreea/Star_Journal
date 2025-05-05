# 🌌 Star App Journal

**Star App Journal** is a digital companion for star enthusiasts and sky gazers to document, explore, and relive their celestial adventures. Whether you're tracking a meteor shower or just observing the night sky, this app lets you log every discovery — online or offline.

---

## ✨ Features

### 📝 Journal Entries

Users can **add, view, update**, and **delete** information about celestial elements they've observed.

Each **Star Entry** includes:

- `name`: Name of the star or celestial body  
- `radius`: Radius (in kilometers or solar radii)  
- `position`: X and Y coordinates  
- `temperature`: Temperature in Kelvin (or `"unknown"`)  
- `galaxy`: The galaxy the star belongs to  
- `constellation`: The related constellation  
- `description`: Personal notes or observations  
- `photo`: Image link provided by the user  

---

## 🔄 CRUD Operations

| Action  | Description |
|---------|-------------|
| **Read**   | View all observed stars with full details |
| **Add**    | Add a new star with complete observation details |
| **Update** | Modify existing entries — any field can be edited, including marking temperature as `"unknown"` |
| **Delete** | Remove stars with incorrect or duplicate entries |

---

## 📶 Offline Functionality

Star App Journal works **seamlessly offline**, storing all changes locally and **synchronizing automatically** when the device is back online.

- ✅ **Offline**
  - Create stars (stored locally in SQLite)
- 🔁 **Sync**
  - Upon reconnection, all local changes are pushed to the server

---

## 🌐 Data Flow

```mermaid
graph TD
  A[User Input] --> B[Local DB]
  B --> C{Online?}
  C -- No --> D[Stored Locally]
  C -- Yes --> E[Sync to Server]
  D -->|When online| E
