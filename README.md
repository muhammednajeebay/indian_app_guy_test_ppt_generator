# indian_app_guy_test_ppt_generator

A new Flutter project.
# Flutter Assignment

Welcome!

Your task is to build a simple Flutter app that uses **MagicSlides Topic → PPT API** to generate presentations from a topic.

---

# 📌 **What You Need to Build**

## **1. Authentication (Signup + Login)**

- Create **Signup** and **Login** screens.
- User registers using:
    - Email
    - Password
- Save users in **Supabase OR MongoDB** (choose any).
- After login, the user should stay logged in (persistent session).
- After successful login → redirect to **Home Screen**.

---

## **2. Home Screen**

This should contain:

### ✅ **Topic Input**

- A simple text field:
    - "Enter your topic…"

### ✅ **Two Options**

- **Default Template**
- **Editable Template**

User selects one.

✅ **Third Options**

### Suggested fields:

- Slide Count (1–50)
- Language (default: `en`)
- Template dropdown (from template list below)
- AI Images: ON/OFF
- Image on each slide: ON/OFF
- Google Images: ON/OFF
- Google Text: ON/OFF
- Model: `gpt-4` or `gpt-3.5`
- Presentation For (student, teacher, business, etc.)
- Optional Watermark fields:
    - width
    - height
    - brandURL
    - position

Keep this simple. No need for perfect UI.

### ✅ **Generate Button**

After choosing settings → user clicks generate and you will show them results

---

---

## **4. API Integration**

Use this endpoint:

```
POST https://api.magicslides.app/public/api/ppt_from_topic
```

### **Required Body Fields**

```json
{
  "topic": "Your topic",
  "email": "your-email@example.com",
  "accessId": "YOUR_HARDCODED_ACCESS_ID",
  "template": "bullet-point1"
}
```

You will get a **hardcoded accessId** from us.

⚠️ Do NOT add signup/login for the MagicSlides API.

Use only our provided accessId.

---

## **5. Show Output**

After API call:

### ✔ Show a PDF preview of the generated presentation

Use **any PDF viewer plugin**.

### ✔ Show "Download" button

User can download the PPT/PDF file to phone storage.

### ✔ Handle errors

Show clean messages if:

- Topic is empty
- API fails
- No internet

---

---

# ⭐ **Extra Points (Optional)**

- Add a dark/light mode toggle.
- Add animations using `AnimatedContainer` or Lottie.
- Add logout button.
- Add Google Slides icon or a small MagicSlides-style header.

---

# 📦 **Final Submission**

Please submit:

- ✔ GitHub Repository Link
- ✔ APK (Android)
- ✔ Short README with:
    - How to run
    - Database used
    - Architecture
    - Known issues

A Video demo

---

# 🧪 **Evaluation Criteria**

| Criteria | Weight |
| --- | --- |
| Signup/Login + Database | 20% |
| API Integration | 25% |
| PDF Preview + Download | 20% |
| Clean Code + Structure | 20% |
| UI/UX | 15% |

---

# 🧠 **MagicSlides API — Topic to PPT (Full Reference)**

### **Endpoint**

```
POST https://api.magicslides.app/public/api/ppt_from_topic
```

---

## **Request Parameters**

| Field | Type | Required | Notes |
| --- | --- | --- | --- |
| topic | string | Yes | Topic for PPT |
| extraInfoSource | string | No | Additional context |
| email | string | Yes | Your registered email |
| accessId | string | Yes | Hardcoded |
| template | string | No | Default: bullet-point1 |
| language | string | No | Default: en |
| slideCount | number | No | 1–50, default: 10 |
| aiImages | boolean | No | Default: false |
| imageForEachSlide | boolean | No | Default: true |
| googleImage | boolean | No | Default: false |
| googleText | boolean | No | Default: false |
| model | string | No | gpt-4 / gpt-3.5 |
| presentationFor | string | No | Audience |
| watermark | object | No | Optional image watermark |

---

## **Supported Templates**

### **Editable**

- ed-bullet-point9
- ed-bullet-point7
- ed-bullet-point6
- ed-bullet-point5
- ed-bullet-point2
- ed-bullet-point4
- custom gold 1
- custom Dark 1
- custom sync 1–6
- custom-ed-7 to custom-ed-12
- pitchdeckorignal
- pitch-deck-2
- pitch-deck-3
- ed-bullet-point1

### **Default**

- bullet-point1
- bullet-point2
- bullet-point4
- bullet-point5
- bullet-point6
- bullet-point7
- bullet-point8
- bullet-point9
- bullet-point10
- custom2–custom9
- verticalBulletPoint1
- verticalCustom1

---

## **Example Request**

```json
{
  "topic": "Artificial Intelligence in Healthcare",
  "extraInfoSource": "Focus on recent developments",
  "email": "your-email@example.com",
  "accessId": "your-access-id",
  "template": "bullet-point1",
  "language": "en",
  "slideCount": 10,
  "aiImages": false,
  "imageForEachSlide": true,
  "googleImage": false,
  "googleText": false,
  "model": "gpt-4",
  "presentationFor": "healthcare professionals",
  "watermark": {
    "width": "48",
    "height": "48",
    "brandURL": "https://example.com/logo.png",
    "position": "BottomRight"
  }
}
```

---

## **Example Response**

```json
{
  "success": true,
  "data": {
    "url": "https://example.com/generated.pptx"
  },
  "message": "Presentation generated successfully"
}
```

---

Check this for reference - 
API Docs -  [https://www.magicslides.app/docs-api](https://www.magicslides.app/docs-api/topic)