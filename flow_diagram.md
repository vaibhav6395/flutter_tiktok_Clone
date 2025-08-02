# TikTok Clone App Flow Diagram

```mermaid
flowchart TD
  subgraph App Initialization
    A[main.dart] -->|Initialize Firebase & AuthController| B[AuthController]
    B -->|Check auth state| C{User Logged In?}
    C -- No --> D[Loginscreen]
    C -- Yes --> E[Homescreen]
  end

  subgraph Authentication Flow
    D -->|Login user| B
    D -->|Navigate to| F[Signupscreen]
    F -->|Register user with profile pic| B
  end

  subgraph Homescreen Navigation
    E --> G[Videoscreen]
    E --> H[SerachScreen]
    E --> I[Addvideoscreen]
    E --> J[Message Screen (Placeholder)]
    E --> K[ProfileScreen]
  end

  subgraph Controllers
    B[AuthController]
    L[Videocontroller]
    M[UploadvideoController]
    N[CommentController]
  end

  subgraph Video Feed
    G -->|Fetch videos| L
    L -->|Get videos from Firestore| Firestore[(Firestore)]
    L -->|Like/unlike video| Firestore
  end

  subgraph Video Upload
    I -->|Upload video with metadata| M
    M -->|Upload video & thumbnail to Firebase Storage| Storage[(Firebase Storage)]
    M -->|Save video data| Firestore
  end

  subgraph Comments
    N -->|Fetch comments for video| Firestore
    N -->|Post comment| Firestore
    N -->|Like/unlike comment| Firestore
  end

  subgraph User Profile
    K -->|Display user info| Firestore
    B -->|Upload profile pic| Storage
  end

  subgraph State Management
    B -->|Reactive user state| GetX[(GetX)]
    L -->|Reactive video list| GetX
    N -->|Reactive comment list| GetX
  end

  Firestore -.-> Storage
  Storage -.-> Firestore
