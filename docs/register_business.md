# Business Management & POS App – Istemal aur Test ki Guide (Roman Urdu)

Yeh guide **karobar ke malik (owner), manager aur billing staff / cashier** ke liye tayyar ki gayi hai. Is guide ka maqsad yeh hai ke aap apne karobar (Retail Store, Pharmacy, Mart, Restaurant, Wholesale, ya Bakery) ko is software par asani se set up kar sakein, rozmarra ke tamam karobari hisaab kitab chalayen, aur har module ko **test** karke tasdeeq kar sakein.

Computer ka koi advance ilm hona zaroori nahi. Bas steps tarteeb se follow karein aur jaise jaise kaam hota jaye, check-box par tick karte jayen (☐ → ☑).

> **Mashwara:** Test ke liye shuru mein chand test records (masalan "Test Store", "Test Supplier", "Test Product") istemal karein. Jab sab kuch samajh aa jaye to unhein delete ya clean karke asal karobari data darj karein.

---

## Fehrist (Contents)

0. [Guide mein istemal hone wale lafz](#0-guide-mein-istemal-hone-wale-lafz)
1. [Shuru karne se pehle (Pehle kya tayyar rakhna hai)](#1-shuru-karne-se-pehle-pehle-kya-tayyar-rakhna-hai)
2. [Step 1: Karobar Register Karna aur Owner Account Setup](#2-step-1-karobar-register-karna-aur-owner-account-setup)
3. [Step 2: Categories, Inventory Units (UOM) aur Brands Setup](#3-step-2-categories-inventory-units-uom-aur-brands-setup)
4. [Step 3: Suppliers (Maal supply karne wale distributors)](#4-step-3-suppliers-maal-supply-karne-wale-distributors)
5. [Step 4: Product Catalogue, Barcodes aur Selling Prices](#5-step-4-product-catalogue-barcodes-aur-selling-prices)
6. [Step 5: Customers (Gahak / Khata Ledger)](#6-step-5-customers-gahak--khata-ledger)
7. [Step 6: Purchases aur Goods Receiving (Batch & Expiry ke saath)](#7-step-6-purchases-aur-goods-receiving-batch--expiry-ke-saath)
8. [Step 7: Inventory aur Stock Management (Movements & Adjustments)](#8-step-7-inventory-aur-stock-management-movements--adjustments)
9. [Step 8: Cash Register aur Shift Management (Galla System)](#9-step-8-cash-register-aur-shift-management-galla-system)
10. [Step 9: POS (Point of Sale Counter & Thermal Receipt Printing)](#10-step-9-pos-point-of-sale-counter--thermal-receipt-printing)
11. [Step 10: Sales History aur Returns (Refunds / Exchange)](#11-step-10-sales-history-aur-returns-refunds--exchange)
12. [Step 11: Expenses (Dukaan ke rozmarra ke kharche)](#12-step-11-expenses-dukaan-ke-rozmarra-ke-kharche)
13. [Step 12: Reports aur Karobari Munafa/Nuqsan Analytics](#13-step-12-reports-aur-karobari-munafanuqsan-analytics)
14. [Step 13: Staff Users, Roles aur Permissions Control](#14-step-13-staff-users-roles-aur-permissions-control)
15. [Step 14: Settings aur Devices Setup (Printers, Barcode Scanners)](#15-step-14-settings-aur-devices-setup-printers-barcode-scanners)
16. [Step 15: Offline Mode aur Local Database Sync Engine](#16-step-15-offline-mode-aur-local-database-sync-engine)
17. [Rozana ka Karobari Routine (Subah se shaam tak)](#17-rozana-ka-karobari-routine-subah-se-shaam-tak)
18. [Asal Istemal Se Pehle Aakhri Checklist (Go-Live)](#18-asal-istemal-se-pehle-aakhri-checklist-go-live)
19. [Agar koi masla aaye to developer ko kaise batayen](#19-agar-koi-masla-aaye-to-developer-ko-kaise-batayen)

---

## 0. Guide mein istemal hone wale lafz

| Lafz | Matlab |
|---|---|
| **Business / Karobar** | Aap ki asal entity ya company (masalan "Al-Madina Super Mart" ya "Sehat Pharmacy"). |
| **Branch / Dukaan** | Jahan karobar operate hota hai (e.g. Main Branch, Gulberg Branch). |
| **Business Niche / Type** | Karobar ki qism (Pharmacy, Mart/Grocery, Restaurant, Retail, Bakery, Hardware, Wholesale waghera). Har type ke hisaab se app ke features khud adjust hote hain. |
| **Tax Pricing Choice** | Kya bechi jane wali cheezon ki qeemat mein tax pehle se shamil hai (Inclusive) ya bill par alag se lagega (Exclusive/Add on top). |
| **Owner Account** | Dukaan ke malik ka main login jise har setting aur reports ka poora ikhtiyar hota hai. |
| **Cash Register / Shift** | Cash drawer ya gallay ka session. Har cashier subah opening float ke sath shift kholta hai aur shaam ko cash ginkar shift close karta hai. |
| **Float / Opening Cash** | Shift shuru karte waqt gallay mein jo rezaari ya cash rakha jata hai. |
| **POS (Point of Sale)** | Billing screen jahan se barcode scan karke ya items select karke customer ko bill kata jata hai. |
| **KOT (Kitchen Order Ticket)** | Restaurant business mein kitchen ke chef ko bheja jane wala order slip. |
| **Supplier** | Distributor ya dealer jis se aap dukaan ke liye maal kharidte hain. |
| **Purchase Order (PO)** | Supplier ko bheja jane wala order jis mein mangwaye gaye items aur rate likhe hote hain (is se stock foran nahi barhta). |
| **Goods Receipt (GRN)** | Maal dukaan par physically aane ke baad asal carton/packets ginkar batch aur expiry ke sath stock mein darj karna. |
| **Customer / Khata** | Woh gahak jo udhar (credit) par maal leta ho ya jis ka ledger maintain karna ho. |
| **Stock Movement** | Stock ka andar aana (In), bahar jana (Out), sale hona, ya damage/adjustment ki wajah se tabdeel hona. |
| **Offline Sync** | Internet na hone par bhi app ka chalte rehna aur internet wapas aane par local data ka server ke sath sync ho jana. |

---

## 1. Shuru karne se pehle (Pehle kya tayyar rakhna hai)

### 1.1 Karobar shuru karne ke liye zaroori cheezain

- ☐ **Device**: Android tablet/phone, Windows PC, ya Web browser jahan app chalani hai.
- ☐ **Internet Connection**: Pehli martaba business register karne aur sync activate karne ke liye internet zaroori hai. (Baad mein sales offline bhi ho sakti hain).
- ☐ **Karobari Maloomat**:
  - Karobar ka legal ya marketing naam (e.g. *Bismillah General Store*).
  - Shehar (Karachi, Lahore, Islamabad, Rawalpindi, Faisalabad, waghera).
  - Karobar ka logo (Optional - PNG/JPEG tasveer jo bill par print ho sake).
  - Main branch ka naam aur mukammal pata.
- ☐ **Owner Ki Maloomat**:
  - Malik ka poora naam.
  - Malik ka mobile number (yeh login ke liye username ka kaam dega, e.g. `03001234567`).
  - Aik mazboot password (kam az kam 8 huroof).
- ☐ **Tax aur Pricing Policy**:
  - Kya aap ke rate mein tax shamil hai (Retail/Mart/Pharmacy mein aam taur par inclusive hota hai)?
  - Ya tax subtotal par alag se lagana hai (Restaurants aur wholesale mein aksar alag hota hai)?
  - Ya aap tax charge nahi karte?

### 1.2 Karobar Setup Ki Sahi Tarteeb (Logical Sequence)

Real business ko live karne ke liye hamesha is tarteeb se kaam karein:

| Tarteeb | Marhala (Module) | Maqsad |
|---|---|---|
| **Step 1** | **Business & Owner Registration** | System mein karobar, branch aur malik ka account banana. |
| **Step 2** | **Categories aur Units (UOM)** | Items ke groups (Categories) aur naap-tol ke paimane (Pieces, Kg, Box, Litre) banana. |
| **Step 3** | **Suppliers Record** | Jin dealers se maal kharidna hai unka record tayyar karna. |
| **Step 4** | **Product Catalogue & Pricing** | Items darj karna, barcode lagana aur sale prices mukarrar karna. |
| **Step 5** | **Customers & Khata** | Udhar lene wale customers aur unke purane balance (Opening Balances) likhna. |
| **Step 6** | **Purchase Order & Goods Receipt** | Asal inventory dakhil karna (Batch, Expiry aur kharid qeemat ke sath). |
| **Step 7** | **Inventory Verification** | Physical stock aur system stock ka milan karna. |
| **Step 8** | **Cash Register / Shift Open** | Gallay ka opening cash (float) darj karke counter tayyar karna. |
| **Step 9** | **POS Sales & Receipts** | Counter sale shuru karna aur thermal printer se receipt nikalna. |
| **Step 10** | **Shift Close & Reconciliation** | Din ke aakhir par cash ginkar hisaab barabar karna. |

---

## 2. Step 1: Karobar Register Karna aur Owner Account Setup

Yeh system ka **sab se pehla aur bunyadi qadam** hai. Jab tak business register nahi hoga, baqi koi module dastiyab nahi hoga.

**Kholne ka tareeqa:**
App kholne par agar pehle se koi login nahi hai to **Landing Page** samne aayegi. Wahan **"Get Started"** ya **"Register Business"** ka button dabayein. Yeh 4-step wizard khol dega.

---

### 2.1 Step 1 of 4: Business Profile (Karobari Pehchan)

Is screen par aap ke karobar ki bunyadi pehchan darj hoti hai.

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Business Name** | **Haan (Lazmi)** | Karobar ka asal naam (e.g., `Madina Super Mart`, `Sehat Pharmacy`). Yehi naam receipts aur reports ke sar par chhapta hai. |
| **Operational City** | **Haan (Lazmi)** | Dropdown se apna shehar chunein (e.g., Karachi, Lahore, Islamabad, Rawalpindi, Faisalabad, Peshawar, Quetta waghera). |
| **Currency** | Pehle se tay shuda | Pakistan ke liye default `PKR` select hota hai. |
| **Business Logo** | Ikhtiyari (Optional) | "Upload Logo" par click karke apne phone ya PC se dukaan ka logo lagayein. Yeh customer receipt par print hota hai. |

**Amal (Action):** Sab fields bhar kar neeche **"Next Step: Business Niche"** dabayein. Agar Business Name khali hoga to error aayega: *"Business name is required"*.

---

### 2.2 Step 2 of 4: Business Niche & Tax Choice (Karobar Ki Qism aur Tax)

Is step par karobar ki category select ki jati hai taake app aap ke mutabiq screens aur features customize kar sake.

#### 1. Business Type chunein:
- **Pharmacy**: DRAP standards, Generic formula search, Batch number aur Expiry tracking active karta hai.
- **Restaurant**: Kitchen Order Ticket (KOT), Dining Table / Floor layout aur Food modifiers enable karta hai.
- **Mart / Grocery**: Tez barcode scanning, SKU lookup aur weight-scale support provide karta hai.
- **Bakery / Sweets**: Recipe manufacturing, raw materials aur wazan ke hisaab se pricing handle karta hai.
- **Retail**: Garments, footwear waghera ke liye Variants (Size, Color), barcode aur discounts manage karta hai.
- **Hardware**: Bulk units, thoka udhar aur contractor project ledger banata hai.
- **Wholesale**: Carton banam pieces, tiered wholesale pricing aur credit terms deta hai.
- **Other**: Khula customized setup aam trading ya services ke liye.

#### 2. Tax Pricing Choice (Neeche aane wala ahem sawal):
Screen par sawal aata hai: *"Does the price on your items already include tax?"*

- **"Yes, the price includes tax" (Tax shamil hai)**:
  - *Kahan use hota hai*: Pharmacy, Super Mart aur Retail mein aam taur par pack par jo qeemat chhapi hoti hai us mein tax pehle se shamil hota hai.
- **"No, tax is added on top" (Tax bill par alag se lagana hai)**:
  - *Kahan use hota hai*: Restaurants, Cafes ya aisi jagah jahan 16% / 15% GST/PNT bil ke aakhir mein lagta hai.
- **"I don't charge tax" (Tax nahi lagana)**:
  - Chhoti dukaanein jo tax exemption mein aati hain ya tax charge nahi kartin.

**Amal (Action):** Business type aur tax choice select karke **"Next Step: Branch Info"** dabayein.

---

### 2.3 Step 3 of 4: Branch Info (Pehli Dukaan / Branch)

App multi-branch support karti hai, lekin pehli dafa aap ko apni headoffice ya pehli dukaan darj karni hoti hai.

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Branch Name** | **Haan (Lazmi)** | Dukaan ya outlet ka naam (e.g., `Main Branch`, `G-9 Markaz Branch`, `DHA Branch`). |
| **Address** | Ikhtiyari (Optional) | Mukammal pata (e.g., `Shop # 4, Main Commercial Market`). Yeh thermal receipt par print hoga. |
| **Branch Phone** | Ikhtiyari (Optional) | Dukaan ka rabta number jo bill par chhapega (e.g., `051-1234567` ya `0300-1234567`). |

**Amal (Action):** Maloomat bhar kar **"Next Step: Owner Profile"** dabayein. Agar Branch Name khali ho to error aayega: *"Branch name is required"*.

---

### 2.4 Step 4 of 4: Owner Profile & Plan Selection (Malik Ka Account)

Yeh account system ka Supreme Administrator hota hai jise har cheez ka access milta hai.

| Field Ka Naam | Zaroori? | Wazahat |
|---|---|---|
| **Owner Full Name** | **Haan (Lazmi)** | Malik ka naam (e.g., `Muhammad Saeed`). |
| **Owner Phone Number** | **Haan (Lazmi)** | Malik ka mobile number. **Yeh number login ke liye username hoga.** (e.g., `03001234567`). Duplicate number allow nahi hota. |
| **Password** | **Haan (Lazmi)** | Kam az kam 8 huroof ka password. Niche password strength indicator (Weak, Fair, Strong) nazar aata hai. |
| **Confirm Password** | **Haan (Lazmi)** | Password dobara likhein taake ghalti na ho. Dono match hone chahiye. |
| **Subscription Plan** | **Haan (Chunna hai)** | 3 plans samne aate hain:<br>1. **Basic** (Rs. 3,000/mo - 1 Branch, 1 User)<br>2. **Growth [Recommended]** (Rs. 6,000/mo - 3 Branches, 5 Users)<br>3. **Pro** (Rs. 10,000/mo - 5 Branches, Unlimited Users) |

**Amal (Action):** Mukammal form bhar kar **"Complete Registration"** dabayein.
- System cloud backend par aap ka tenant, branch, permissions aur owner user create karega.
- Registration complete hone par **Green Check / Registration Success** screen aayegi.
- Wahan se aap direct apne **Main Dashboard / POS Workspace** par dakhil ho jayenge.

---

### 2.5 Test Checklist (Karobar Registration Test Karein)

Naya setup banate waqt is checklist ke mutabiq test karein:

1. ☐ **Form Validation Test**:
   - Step 1 par Business Name khali chhor kar "Next" dabayein. Check karein ke error *"Business name is required"* aata hai.
   - City dropdown se apna shehar chunein.
2. ☐ **Business Niche & Tax Test**:
   - Step 2 par business type select karein (e.g. `Pharmacy` ya `Mart`).
   - Dekhein ke Pharmacy/Mart par default tax choice *"Yes, the price includes tax"* auto-select hoti hai ya nahi.
   - Doosri business types (e.g. `Restaurant`) par *"Tax is added on top"* switch karke dekhein.
3. ☐ **Branch Details Test**:
   - Step 3 par Branch Name darj karein.
   - Address aur phone number likhein aur tasdeeq karein ke text field mein sahi type ho raha hai.
4. ☐ **Owner Phone & Password Security Test**:
   - Step 4 par ghalat ya chhota password (masalan `123`) likhein: system ko weak password reject karna chahiye.
   - Confirm password mein mukhtalif password likhein: system ko *"Passwords do not match"* ka alert dena chahiye.
   - Valid 8+ digit password lagayein taake strength bar green ho jaye.
5. ☐ **Plan Selection & Submission**:
   - Growth plan select karein aur "Complete Registration" dabayein.
   - Internet connection active hona chahiye.
   - Tasdeeq karein ke **"Registration Successful"** screen aati hai aur aap system ke Dashboard mein redirect ho jate hain.
6. ☐ **Login Verification Test**:
   - App se Logout karein.
   - Wapas Login screen par wahi Phone number aur Password likh kar Sign In karein.
   - Tasdeeq karein ke aap baghair kisi rukawat ke apne business ke Dashboard par dakhil ho gaye hain.

---

---

## 3. Step 2: Categories, Inventory Units (UOM) aur Brands Setup

Karobar register karne ke foran baad, **kisi bhi product ya purchase ko dakhil karne se pehle**, items ki categories aur naap-tol ke units (UOM) banana zaroori hota hai.

Agar categories aur units pehle se tayyar na hon, to product banate waqt na unit select hogi aur na hi POS screen par items ko aasani se dhoonda ja sakega.

**Kholne ka tareeqa:**
Sidebar / Menu se **"Products"** par jayein → Upar **"+ New Product"** ka button dabayein.
Product form ke andar har field ke sath **"+ New"** ka button mojood hai jo foran naya category, unit ya brand banata hai.

---

### 3.1 Product Categories aur Subcategories

Category aap ke stock ko mukhtalif hisson mein baant deti hai taake cashier ko POS counter par item dhoondne mein waqt zaya na ho, aur shaam ko pata chal sake ke kis category ki kitni sale hui.

**Quick Add Category Dialog:**
Form par `Category` ke sath **"+ New"** dabayein. Aik pop-up khulega:

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Category Name** | **Haan (Lazmi)** | Category ka naam (e.g., `Medicines`, `Dairy`, `Beverages`, `Fast Food`). |
| **Parent Category** | Ikhtiyari (Optional) | Agar yeh kisi badi category ki shakh (subcategory) hai to dropdown se Parent chunein (e.g., Parent: `Medicines` → Subcategory: `Prescription (Rx)` ya `OTC Medicines`). Agar main category hai to `None` chunein. |

**Save** dabane par category foran save ho jati hai aur dropdown mein auto-select ho jati hai.

#### Real Business Categories Ki Misalein:

- **Pharmacy / Medical Store:**
  - `Medicines` (Parent) → `Prescription (Rx)`, `OTC (General)`, `Syrups`, `Injections`
  - `Vitamins & Supplements`
  - `Medical Devices & Surgical` (e.g., Syringes, Cannula, BP Monitors)
  - `Baby Care & Nutrition` (e.g., Diapers, Baby Milk)
- **Super Mart / Grocery:**
  - `Dairy & Bakery` (Milk, Yogurt, Bread, Eggs)
  - `Beverages` (Cold drinks, Juices, Tea, Coffee)
  - `Staples / Kiryana` (Rice, Flour, Pulses, Sugar, Spices)
  - `Snacks & Confectionery` (Biscuits, Chips, Chocolates)
  - `Personal Care & Toiletries` (Soaps, Shampoos, Toothpaste)
- **Restaurant / Food Corner:**
  - `Appetizers / Starters` (Soups, Fries, Wings)
  - `Fast Food` (Burgers, Sandwiches, Pizzas)
  - `Main Course` (Karahi, Biryani, Handi)
  - `Beverages & Shakes`
  - `Desserts`
- **Retail / Garments:**
  - `Men's Wear` (Shirts, Trousers, Shalwar Kameez)
  - `Women's Wear` (Kurtis, Unstitched, Stitched)
  - `Kids Wear`
  - `Footwear & Accessories`

---

### 3.2 Inventory Units (UOM - Unit of Measure)

Unit batati hai ke maal kis paimane mein kharida aur becha jata hai (masalan adad mein, kilo mein, ya dabbo mein).

**Quick Add Unit Dialog:**
Form par `Base Unit` ke sath **"+ New"** dabayein. Pop-up dabba khulega:

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Unit Name** | **Haan (Lazmi)** | Unit ka mukammal naam (e.g., `Piece`, `Kilogram`, `Litre`, `Tablet`, `Box`, `Strip`). |
| **Symbol** | **Haan (Lazmi)** | Chhoti alamat jo bill aur reports par aayegi (e.g., `pcs`, `kg`, `ltr`, `tab`, `box`, `strip`). |
| **Is base unit** | Checkbox | Agar yeh aakhri chhota paimana hai jis par stock count hota hai to check (tick) karein. Aam taur par single item / piece / kg ko base unit banaya jata hai. |

**Save** dabayein. Unit database mein save ho kar dropdown mein select ho jayegi.

> **Ahem Karobari Usool (Golden Rule of Units):**
> Hamesha apni **Base Unit** woh rakhein jis par POS counter par aam customer ko maal becha jata hai:
> - Agar aap dawayi goli (tablet) ke hisaab se bechte hain to base unit `Tablet (tab)` banayein.
> - Agar aap dawayi sirf poori dibbi ya strip bechte hain to base unit `Strip` ya `Box` banayein.
> - Sabzi, phal aur kiryana ke liye base unit `Kilogram (kg)` ya `Gram (g)` banayein.
> - Pack items (chips, cold drink, soap) ke liye base unit `Piece (pcs)` banayein.

---

### 3.3 Brands / Manufacturers (Optional Magar Mufeed)

Brand se pata chalta hai ke item kis company ka hai. Yeh stock audit aur company-wise sales dekhne mein bohat madad deta hai.

**Quick Add Brand Dialog:**
Form par `Brand` ke sath **"+ New"** dabayein:
- **Brand Name**: Company ka naam likhein (e.g., `GSK`, `Getz Pharma`, `Abbott`, `Nestle`, `Unilever`, `National Foods`).
- **Save** dabayein. Brand foran create ho jayega.

---

### 3.4 Test Checklist (Categories aur Units Test Karein)

1. ☐ **Main Category banana**:
   - Products → `+ New Product` kholo.
   - Category ke sath `+ New` dabao.
   - Category Name: `Test Medicines` (ya apni dukaan ke mutabiq main category), Parent: `None`.
   - `Save` dabao. Tasdeeq karo ke dialog band ho gaya aur dropdown mein `Test Medicines` select ho gaya.
2. ☐ **Subcategory banana (Parent-Child test)**:
   - Dobara `+ New` dabao.
   - Category Name: `Test OTC Products`.
   - Parent category dropdown se pehle banayi gayi `Test Medicines` select karo.
   - `Save` dabao. Tasdeeq karo ke subcategory save ho gayi.
3. ☐ **Base Unit banana**:
   - `Base Unit` field ke sath `+ New` dabao.
   - Unit Name: `Piece`, Symbol: `pcs`, `Is base unit`: Tick (ON).
   - `Save` dabao. Dropdown mein `Piece (pcs)` nazar aana chahiye.
4. ☐ **Doosri Unit banana (Liquid / Weight)**:
   - Apne business ke mutabiq `Kilogram (kg)` ya `Tablet (tab)` ya `Litre (ltr)` add karein.
   - Save karke verify karein ke dono units dropdown mein alag alag dastiyab hain.
5. ☐ **Khali Field Validation Test**:
   - `+ New` Category ya Unit dabba khol kar naam khali chhor kar Save dabayein: system ko baghair naam ke record save nahi karna chahiye.
6. ☐ **Form Cancel & Data Safety Test**:
   - Naya product save kiye baghair product form se bahar (Back) nikal jayein.
   - Dobara `+ New Product` khol kar Category aur Unit ke dropdowns check karein:
   - **Check**: Jo categories aur units aap ne banaye the woh database mein mehfooz rehte hain, product cancel karne se delete nahi hote.

---

---

## 4. Step 3: Suppliers (Maal supply karne wale distributors)

Real business mein stock hawa se nahi aata; har dukaan kisi na kisi dealer, distributor, company ya wholesaler se maal khareedti hai.

Stock khareedne (Purchase Order / Goods Receipt) se pehle apne **Suppliers (Distributors)** ka record system mein darj karna zaroori hota hai taake:
1. Har purchase invoice us supplier ke naam par record ho sake.
2. Supplier ka udhar khata (**Outstanding Balance / You'll give**) track ho sake.
3. Supplier ke credit days (**Payment Terms**) ke mutabiq payment ki planning ho sake.

**Kholne ka tareeqa:**
Sidebar / Menu se **"Suppliers"** par click karein.
Upar toolbar par total suppliers ki tadaad, search bar aur **"Add Supplier"** ka button nazar aayega.

---

### 4.1 Supplier Form (Naya Supplier Darj Karna)

Toolbar par **"Add Supplier"** dabayein. Aik mukammal form samne aayega:

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Name** | **Haan (Lazmi)** | Distributor ya Agency ka karobari naam (e.g., `Ali Pharma Distributors`, `Nestle Distribution Hub`, `Al-Rehman Foods`). |
| **Contact Person** | Ikhtiyari (Optional) | Order booker ya sales representative ka naam (e.g., `Kamran Sales Officer`). |
| **Email** | Ikhtiyari (Optional) | Official email pata (e.g., `sales@distributor.com`). |
| **Phone** | Ikhtiyari (Optional) | Rabta number / Mobile number (e.g., `03001234567`). |
| **Tax ID** | Ikhtiyari (Optional) | FBR NTN ya Sales Tax / STRN number (e.g., `1234567-8`). |
| **Address** | Ikhtiyari (Optional) | Distributor ka warehouse ya office address (e.g., `Shop 12, Wholesale Market, Lahore`). |
| **City** | Ikhtiyari (Optional) | Shehar ka naam (e.g., `Lahore`, `Karachi`). |
| **Payment Terms (days)** | Default 30 | Kitne dino ka udhar time milta hai (e.g., `15`, `30`, ya cash par ho to `0`). |

**Amal (Action):** Sab fields bhar kar **"Create Supplier"** dabayein. Green alert aayega: *"Supplier created"*.

---

### 4.2 Suppliers List aur Balance Tracking

Suppliers table mein har supplier ki mandarja zail maloomat nazar aati hain:
- **Name & Contact Person**: Distributor ka naam aur uske representative ka naam.
- **Phone**: Call ya WhatsApp ke liye rabta number.
- **Outstanding Balance**: Aap ne is distributor ko kitne paise dene hain (Accounts Payable). Jab bhi purchase enter hogi, unpaid raqam yahan khud-ba-khud jama ho jayegi.
- **Status Badge**: `Active` (green badge) ya `Inactive`.
- **Actions**:
  - **Edit (Pencil Icon)**: Supplier ki contact info ya credit terms tabdeel karne ke liye.
  - **Delete (Trash Icon)**: Agar ghalti se ban gaya ho to delete karne ke liye.

> **Ahem Usool:** Jis supplier ke naam par pehle se koi Purchase Order ya Goods Receipt darj ho chuki ho, usay delete karne ki ijazat nahi hoti taake dukaan ka purana hisaab aur audit kharab na ho.

---

### 4.3 Test Checklist (Suppliers Module Test Karein)

1. ☐ **Naya Supplier Banayein**:
   - `Suppliers` screen par jayein aur `Add Supplier` dabayein.
   - Name: `Test Distributor`, Contact: `Asif Khan`, Phone: `03001112233`, Payment Terms: `30`.
   - `Create Supplier` dabayein. Tasdeeq karein ke list mein naya supplier `Rs. 0.00` balance ke sath show ho gaya hai.
2. ☐ **Khali Name Validation Test**:
   - Dobara `Add Supplier` kholein aur Name khali chhor kar `Create Supplier` dabayein.
   - Tasdeeq karein ke form submit nahi hota aur error aata hai.
3. ☐ **Search Bar Test**:
   - Search box mein supplier ka naam ya phone number type karein.
   - Check karein ke search filter foran kaam karta hai aur sirf mutaaliqa record dikhata hai.
4. ☐ **Edit Supplier Test**:
   - Row par click karein ya Pencil icon dabayein.
   - Phone ya Payment terms badal kar `Save Changes` karein.
   - Tasdeeq karein ke tabdeeli list mein foran update ho gayi.
5. ☐ **Delete Supplier Test**:
   - Test supplier par Trash icon dabayein. Confirmation dialog mein `Yes` karein.
   - Tasdeeq karein ke record list se remove ho gaya.

---

---

## 5. Step 4: Product Catalogue, Barcodes aur Selling Prices

Categories, Units aur Suppliers banne ke baad dukaan ke **Products (Items)** catalogue mein dakhil kiye jaate hain.

Catalogue mein item darj karne se:
1. Supplier se maal mangwate waqt Purchase Order mein item chuna ja sakta hai.
2. Har item ka apna Barcode, Unit aur Expiry tracking rule set ho jata hai.
3. POS counter par cashier barcode scan karke ya naam likh kar foran bill bana sakta hai.

> **Ahem Karobari Baat:** Naya product banate waqt stock haath se nahi bhara jata. Asal stock Step 6 (Purchases & Goods Receiving) mein invoice aur batch/expiry ke sath dakhil hoga. Yahan sirf item ki pehchan aur uski sale price tay hoti hai.

**Kholne ka tareeqa:**
Sidebar / Menu se **"Products"** par jayein → Upar **"+ New Product"** dabayein.

---

### 5.1 Product Form Ke 4 Ahem Tabs

Form ke upar 4 tabs hain jo mukammal product configuration karte hain:

#### Tab 1: Details (Bunyadi Maloomat, Stock Rules & Tax)
Is tab par item ki basic identification hoti hai:

| Field / Section | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Product Name** | **Haan (Lazmi)** | Item ka mukammal naam (e.g., `Panadol 500mg Tablet`, `Olper Milk 1 Litre`, `Cotton T-Shirt L`). |
| **SKU** | Ikhtiyari (Optional) | Dukaan ka internal stock code (e.g., `MED-001`, `GRO-102`). Khali chhorne par system khud generate kar leta hai. |
| **Category** | Ikhtiyari (Mufeed) | Dropdown se category chunein (e.g., `Medicines` ya `Beverages`). Sath `+ New` ka button bhi hai. |
| **Brand** | Ikhtiyari (Optional) | Company ka naam chunein (e.g., `GSK`, `Nestle`). |
| **Base Unit** | **Haan (Lazmi)** | Naap ka bunyadi paimana (e.g., `Piece (pcs)`, `Tablet (tab)`, `Kilogram (kg)`). |
| **Product Type** | Default: Standard | `Standard` (aam item), `Variant` (size/color), `Composite` (deals/bundle), `Manufactured` (bakery/production), `Service` (marammat/service). |
| **Tracking Type** | Karobar ke mutabiq | - `None`: Aam grocery items jinki expiry nahi dekhni hoti.<br>- `Expiry`: Medicines aur food items ke liye (Batch No aur Expiry lazmi hoti hai).<br>- `Batch`: Batch number tracking.<br>- `Serial`: Electronics aur mobile phones ke liye IMEI / Serial number. |
| **Shelf Life (days)** | Expiry par active | Item kitne din tak sale ke qabil rehta hai (Expiry alert ke liye). |
| **Track Expiry** | Switch (ON/OFF) | Medicines aur khaney peeney ki cheezon ke liye ON karein. POS counter hamesha purana/jald expire hone wala stock pehle bechega (FIFO/FEFO). |
| **Stock & Availability** | Switches | - **Is Sellable**: ON (POS par bechne ke liye).<br>- **Is Purchasable**: ON (Supplier se khareedne ke liye).<br>- **Min Stock Level**: Is se kam stock ho to "Low Stock Alert" aayega.<br>- **Max Stock Level**: Dukaan mein hadd se zyada stock jama hone se rokne ke liye. |
| **Product Tax** | Card | Karobar ki default tax setting use karein ya kisi makhsoos item par alag GST/Tax rate lagayein. |
| **Product Image** | Optional | Item ki tasveer upload karein (PNG/JPG). |

---

#### Tab 2: Variations (Variants - Size / Color / Packing)
- Agar aap ka item single standard item hai, to is tab ko **skip** kar dein. System khud aik default variation bana dega.
- Agar aap ke item ke mukhtalif sizes ya packings hain (masalan `Small`, `Medium`, `Large` ya `500ml`, `1 Litre`), to **"Add Variation"** dabakar rows shamil karein:
  - Name, SKU, Unit, Weight (grams) aur Default checkbox.

Dalda Cooking Oil aata hai. Ab Dalda Oil aik hi brand hai, lekin us ki packing mukhtalif hai:
• Main Item: Dalda Cooking Oil
• Is ki Variations (Rows):
	1. 1 Litre Pouch (Price: 550)
	2. 2.5 Litre Bottle (Price: 1,350)
	3. 5 Litre Can (Price: 2,650)
Is tarah aap ko 3 alag alag items banane ke bajaye aik hi jagah par Dalda Oil ke teeno sizes ka stock aur rate nazar aa jaye ga.
---

#### Tab 3: Barcodes (Barcode Scanner Ke Sath Link Karna)
Item par chhape hue barcode ko scan karne ke liye:
1. **"Add Barcode"** dabayein.
2. `Barcode` field mein click karein aur apne **USB handheld barcode scanner** se item ke dabbe par scanner chalayein. Barcode number khud-ba-khud type ho jayega. (Aap keyboard se haath se bhi type kar sakte hain).
3. **Type**: `EAN13` (aam pack items), `UPC`, `CODE128`, ya `QR`.
4. **Variation**: Agar mukhtalif packing hain to barcode ko makhsoos variation ke sath jorein.

> **Save Action:** Teeno tabs bharne ke baad neeche **"Save Product"** dabayein. Product save ho kar Products List mein nazar aane lagega.

---

#### Tab 4: Pricing (Retail Selling Price Mukarrar Karna)
Product pehli martaba create karne ke baad uski retail price set ki jati hai:
1. Products list mein us product par click karein ya **Pencil (Edit)** icon dabayein.
2. Ab form ke upar chautha tab **"Pricing"** nazar aayega.
3. `Pricing` tab kholein:
   - **Price \***: Customer ko jis rate par bechna hai woh raqam darj karein (e.g., `Rs. 50.00`).
   - **Min Qty (optional)**: Wholesale tier pricing ke liye (e.g., 10 pieces lene par sasta rate).
4. **"Set Price"** ka button dabayein.
5. Green alert aayega: *"Price saved successfully"*. Ab yeh item POS counter par is rate par bike ga.

---

### 5.2 Products List Page Ke Features

- **Search Bar**: Item ke naam ya SKU se foran search karein.
- **Direct USB Barcode Scan**: Products list par rehte hue kisi bhi product ka barcode scan karein; system foran us product ki details khol dega.
- **Filter by Category & Brand**: Makhsoos category ya brand ke items alag karke dekhein.
- **Import / Export**: Excel / CSV file se hazaron products aik click par import ya export karein.

---

### 5.3 Test Checklist (Product Catalogue Test Karein)

1. ☐ **Standard Product Banana**:
   - `Products` → `+ New Product` kholo.
   - Name: `Test Panadol Tablet`, Category: `Test Medicines`, Base Unit: `Tablet (tab)`.
   - Tracking Type: `Expiry` chunein aur `Track Expiry` switch ON karein.
   - `Save Product` dabao. Tasdeeq karo ke product bina kisi error ke save ho gaya.
2. ☐ **Barcode Add Karne Ka Test**:
   - Product edit karo aur `Barcodes` tab par jao.
   - `Add Barcode` dabao aur barcode number darj karo (e.g., `8964000112233`).
   - Save Changes karo.
   - Wapas Products list par ja kar wahi barcode search box mein likhein / scan karein; tasdeeq karein ke product foran nikal aata hai.
3. ☐ **Retail Price Set Karne Ka Test**:
   - Product edit karke `Pricing` tab kholo.
   - Price field mein `15.00` likho aur `Set Price` dabao.
   - Tasdeeq karo ke *"Price saved successfully"* ka message aaya aur current retail price `Rs. 15.00` show ho gayi.
4. ☐ **Khali Name Validation Test**:
   - `+ New Product` kholein aur bina naam ke Save dabayein: system ko *"Product Name is required"* ka error dena chahiye.
5. ☐ **Zero Stock Tasdeeq**:
   - Products list mein dekhein: Naye product ka stock abhi `0` nazar aana chahiye, kyunke stock sirf Goods Receipt (GRN) se barhta hai.

---

---

## 6. Step 5: Customers (Gahak / Khata Ledger)

Dukaan par do tarah ke gahak aate hain:
1. **Walk-in / Counter Gahak**: Jo achanak aate hain, cash/card dete hain aur saaman le kar chale jaate hain. Inka record save karne ki zaroorat nahi hoti (POS inhein direct cash sale treat karta hai).
2. **Khata / Udhar aur Regular Gahak**: Jinhein udhar par maal becha jata hai, ya jinhein makhsoos wholesale/VIP discount rate diya jata hai. Inka record system mein darj karna zaroori hota hai.

**Kholne ka tareeqa:**
Sidebar / Menu se **"Customers"** par click karein.
Upar toolbar par total customers, filters (All, Has Balance), search bar aur **"Add Customer"** ka button nazar aayega.

---

### 6.1 Customer Form (Naya Customer / Khata Darj Karna)

Toolbar par **"Add Customer"** dabayein. Aik asaan form khulega:

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Name** | **Haan (Lazmi)** | Gahak ka poora naam ya dukan/firm ka naam (e.g., `Haji Muhammad Aslam`, `Al-Rehman Clinic`). |
| **Phone** | Ikhtiyari (Optional) | Mobile number (e.g., `03001234567`). POS counter par phone number type karke bhi gahak search ho jata hai. |
| **Email** | Ikhtiyari (Optional) | E-mail address (agar invoice email karni ho). |
| **Address** | Ikhtiyari (Optional) | Gahak ka pata ya muhalla (e.g., `House 45, Street 2, Rawalpindi`). |
| **City** | Ikhtiyari (Optional) | Shehar (e.g., `Rawalpindi`). |
| **Credit Limit** | Default: 0 | **Udhar ki hadd (Rupees mein)**. Agar aap chahte hain ke yeh gahak Rs. 20,000 se zyada udhar na le sake, to yahan `20000` likhein. Hadd poori hone par POS udhar sale block karega. (Agar `0` ho to koi limit nahi hoti). |
| **Tax ID** | Ikhtiyari (Optional) | NTN number agar corporate client ho. |
| **Assigned Price List** | Default / None | Agar is gahak ko aam rate se sasta ya wholesale rate dena ho to makhsoos Price List select karein. POS is gahak ka bill banate waqt khud wohi sasta rate lagayega. |

**Save Action:** Maloomat bhar kar **"Create Customer"** dabayein. Customer create ho kar list mein aa jayega.

---

### 6.2 Customer Ledger (Khata Dekhna aur Wasooli / Payment Enter Karna)

Customers table mein har customer ke aage uska **Outstanding Balance** (Usne aap ko kitne paise dene hain) nazar aata hai:
- Row par click karne ya **Eye/Book Icon** dabane se **Customer Ledger (Mukammal Khata)** khulta hai.
- Ledger mein purani tamam Sales, Wapsi (Returns) aur Wasooliyan (Payments) tareekh-war running balance ke sath nazar aati hain.

#### Khata Ki Wasooli (Record Payment):
Jab gahak dukaan par udhar wapas karne aaye:
1. Customer Ledger screen par upar **"Record Payment"** ka button dabayein.
2. Aik pop-up dabba khulega:
   - **Amount (Rs.)**: Jitne paise gahak ne diye (e.g., `5000`).
   - **Payment Method**: `Cash`, `Bank Transfer`, `Card`, ya `Online / JazzCash`.
   - **Reference No**: Agar bank ya online transaction ho to cheque ya TID number.
   - **Notes**: Koi khas wazahat (masalan "Part payment").
3. **"Save Payment"** dabayein.
4. **Hisaab Khud Barabar Hoga**:
   - ✔ Gahak ke khate se raqam kam ho jayegi.
   - ✔ Agar cash wasool hua to current shift ke gallay (**Cash in hand**) mein raqam khud shamil ho jayegi.

---

### 6.3 Test Checklist (Customers Module Test Karein)

1. ☐ **Naya Customer Banayein**:
   - `Customers` → `Add Customer` kholein.
   - Name: `Test Ali Customer`, Phone: `03219876543`, Credit Limit: `10000`.
   - `Create Customer` dabayein. Tasdeeq karein ke customer list mein `Rs. 0.00` balance ke sath show ho gaya.
2. ☐ **Khali Name Validation Test**:
   - Dobara form kholein aur Name khali chhor kar submit karein: system ko save rokk kar error dena chahiye.
3. ☐ **Ledger Khata Test**:
   - List mein `Test Ali Customer` par click karke ledger screen kholein.
   - Tasdeeq karein ke shuru mein balance `Rs. 0.00` aur table khali hai.
4. ☐ **Record Payment Test (Wasooli)**:
   - Ledger mein `Record Payment` dabayein.
   - Amount: `1000`, Method: `Cash`, Note: `Advance Payment` likh kar Save karein.
   - Tasdeeq karein ke entry ledger mein show ho gayi aur balance update ho gaya.
5. ☐ **Search Bar Test**:
   - Customers list mein ja kar naam ya mobile number se search karein; gahak foran filter hona chahiye.

---

---

## 7. Step 6: Purchases aur Goods Receiving (Batch & Expiry ke saath)

Real business mein stock dakhil karne ka yeh **wahid aur sahih tareeqa** hai.

Bohot se log yeh ghalti karte hain ke product banate waqt direct stock likh dete hain. Is software mein aisa nahi hota kyunke:
1. **Purchase Order (PO)** supplier ko bheja jane wala order hai (is se stock nahi barhta).
2. **Goods Receipt (GRN)** delivery aane par physical cartoon/dabbay ginkar asal **Batch No** aur **Expiry** ke sath stock barhane ka amal hai.
3. Supplier ka udhar khata (**Accounts Payable / You'll give**) bhi invoice ki tasdeeq par khud barhta hai.

---

### 7.1 Marhala 1: Purchase Order (PO) Banana

Jab dukaan mein kisi item ka stock kam ho ya naya stock mangwana ho:

**Kholne ka tareeqa:**
Sidebar / Menu se **"Purchases"** par jayein → Upar **"New Purchase Order"** dabayein.

#### 1. Order Details (Header Card):
- **Supplier \***: Dropdown se distributor chunein (e.g., `Ali Pharma Distributors`). Sath `+` icon se foran naya supplier bhi banaya ja sakta hai.
- **Expected Date**: Jis tareekh ko delivery aane ki umeed ho (Calendar se chunein).
- **Notes**: Koi hidayat (e.g., "Urgent delivery required").

#### 2. Line Items (Mangwaye jane wale items):
**"Add Line"** dabayein aur har item ke liye:
- **Product \***: Dropdown se product select karein (e.g., `Panadol 500mg Tablet`).
- **Variation**: Agar packing ho to select karein (default variation khud lag jati hai).
- **Ordered Qty**: Kitni miqdaar mangwani hai (e.g., `100`).
- **Cost/Unit**: Supplier se jis kharid qeemat par tay hua hai (e.g., `Rs. 10.00`).
- **Tax %**: Agar supplier invoice par tax lagata hai to tax percentage (warna `0`).

#### 3. Submission:
Neeche do buttons hain:
- **Save as Draft**: Agar order abhi mukammal nahi hua aur baad mein mazeed items shamil karne hon.
- **Save & Submit**: Order finalize karke supplier ko bhejne ke liye.
Status `Submitted` ho jayega.

> **Zehn mein rakhein:** PO submit karne se dukaan ki inventory mein stock **nahi** barhta. Stock sirf aglay step (Goods Receipt) par barhega.

---

### 7.2 Marhala 2: Goods Receipt (GRN) — Maal Receive Karna

Jab distributor ka delivery boy dukaan par carton / carton lekar pohnch jaye aur hath mein delivery chalan / invoice pakdaye:

1. `Purchases` list kholein aur us `Submitted` order par click karein.
2. Order details screen par upar **"Receive Goods"** ka button dabayein.
3. **Goods Receipt Screen** khul jayegi:

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Received Date** | Default: Aaj | Jis tareekh ko asal mein maal dukan par aaya. |
| **Supplier Invoice No** | Ikhtiyari (Mufeed) | Distributor ke chalan ya bill ka number (e.g., `INV-88902`). |
| **Notes** | Ikhtiyari | Maal ki haalat ya receiving ka note. |

#### Line Items Receiving (Asal Stock Gin Kar Likhna):
Order ke har item ke samne:
- **Qty Receiving**: Asal physically giney hue dabbe/pieces likhein (e.g., `100`). Agar supplier ne kam bheja ho (masalan 100 mangwaye the aur 80 aaye), to yahan `80` likhein (zabardasti poora na karein).
- **Cost/Unit**: Delivery chalan par likha hua asal kharid rate verify karein.
- **Batch No \***: Agar item medicines ya food category ka hai to **dabbe ke upar chhappi hui asal batch number** note karke likhein (e.g., `B-9042`).
- **Expiry Date \***: Calendar se **dabbe par chhappi hui manufacturer expiry** select karein (e.g., `2027-12-31`).

4. **"Confirm Receipt"** ka button dabayein.

#### System Ke Andar Kya Hoga:
- ✔ Dukaan ki **Inventory / Stock foran barh jayegi**.
- ✔ Batch number aur Expiry inventory lot mein record ho jayegi.
- ✔ Supplier ke khate mein bill ki total raqam (**You'll give**) shamil ho jayegi.
- ✔ Order ka status `Received` (ya agar kam maal aaya ho to `Partially Received`) ho jayega.

---

### 7.3 Test Checklist (Purchase & Receiving Test Karein)

1. ☐ **Naya Purchase Order Submit Karein**:
   - `Purchases` → `New Purchase Order` kholein.
   - Supplier: `Test Distributor`, Item: `Test Panadol Tablet`, Qty: `50`, Cost: `10.00`.
   - `Save & Submit` dabayein. Tasdeeq karein ke order list mein status `Submitted` show ho gaya.
2. ☐ **Stock Check (Pehle)**:
   - `Products` list mein ja kar `Test Panadol Tablet` ka stock dekhein: yeh abhi bhi `0` hona chahiye.
3. ☐ **Goods Receipt Confirm Karein**:
   - PO detail khol kar `Receive Goods` dabayein.
   - Invoice No: `CHALAN-001`, Qty Receiving: `50`, Cost: `10.00`.
   - Batch No: `TEST-BATCH-01`, Expiry: Aglay saal ki tareekh chunein.
   - `Confirm Receipt` dabayein.
4. ☐ **Stock Check (Baad Mein)**:
   - Wapas `Products` list ya `Inventory` screen par jayein:
   - **Tasdeeq**: Stock `0` se barh kar **`50`** ho chuka hai!
5. ☐ **Supplier Khata / Balance Check**:
   - `Suppliers` list khol kar `Test Distributor` ka balance dekhein:
   - **Tasdeeq**: Outstanding balance `Rs. 500.00` (50 qty × Rs. 10.00) ho chuka hai.

---

---

## 8. Step 7: Inventory aur Stock Management (Movements & Adjustments)

Goods Receipt (GRN) enter hone ke baad dukaan ka stock **Inventory Module** mein zinda ho jata hai.

Is module ka asal maqsad dukaan ke stock ki nigrani karna hai:
1. Kis item ka kitna stock dukaan mein mojood hai (**Current Stock**).
2. Konsi cheez khatam hone wali hai (**Low Stock Alert**).
3. Konsi dawa ya food item expire hone wala hai (**Near-Expiry Report**).
4. Agar dukaan mein koi cheez toot jaye ya physical ginti mein farq aaye to usay theek karna (**Stock Adjustment**).

**Kholne ka tareeqa:**
Sidebar / Menu se **"Inventory"** par click karein.
Yahan do ahem screens milti hain: **Inventory Stock** aur **Stock Movements**.

---

### 8.1 Inventory Stock Screen (Mojooda Stock)

Inventory table mein dukaan ke har item ki live soorat-e-haal nazar aati hai:

| Column Ka Naam | Matlab aur Wazahat |
|---|---|
| **Product** | Item ka naam aur brand. |
| **Variation** | Size / Color / Packing (agar ho). |
| **Category** | Item ki category. |
| **Current Stock** | Dukaan ke shelf / warehouse mein abhi kitni miqdaar mojood hai. |
| **Min Level** | Item banate waqt set kiya gaya kam az kam stock level. Agar Current Stock is se kam ho to **Low Stock (Laal rang)** ka alert nazar aata hai. |
| **Unit** | Naap ka paimana (pcs, kg, tab, box). |
| **Last Movement** | Aakhri martaba yeh maal kab aaya ya bika. |

**Toolbar Filters:**
- **Search Bar**: Kisi bhi item ko foran dhoondein.
- **Category Filter**: Sirf makhsoos category ka stock dekhein.
- **Low Stock Filter**: Sirf woh items filter karein jinhein foran dobara mangwana zaroori hai.
- **Export**: Poori stock list Excel / CSV file mein download karein.

---

### 8.2 Stock Adjustment (Ginti Ka Farq Ya Nuqsan Theek Karna)

> **Ahem Karobari Usool:** Purchase receive karne ke baad alag se Stock Adjustment **hargiz na karein**, warna stock do guna (double) ho jayega!
> Adjustment sirf us waqt karein jab physical dukaan mein kisi cheez ka farq aaye.

#### Kab istemal karein:
- **Count Correction**: Mahana ya haftawar physical audit par ginti ka farq nikal aana.
- **Damage**: Bottle toot gayi, carton phatt gaya ya packing kharab ho gayi.
- **Theft**: Chori ya gumshuda maal ka hisaab barabar karna.
- **Expiry**: Expired maal ko shelf se hata kar discard karna.

#### Tareeqa:
1. Item ki row par click karein aur **"Adjust Stock"** dabayein.
2. Pop-up dabba khulega:
   - **Type**: `Add Stock (+)` ya `Deduct Stock (-)`.
   - **Reason**: Dropdown se wajah chunein (`Count Correction`, `Damage`, `Theft`, `Expiry`).
   - **Quantity**: Kitne pieces ka farq hai (e.g., `2`).
   - **Cost Per Unit**: Agar purchase cost note karni ho.
   - **Notes**: Tafseel (masalan "1 bottle broken during cleaning").
3. **Save** dabayein. Stock foran theek ho jayega aur audit log mein record ho jayega.

---

### 8.3 Stock Movements (Har Piece Ka Mukammal Hisaab)

Agar kabhi shaq ho ke kisi item ka stock kyun kam ya zyada hua:
- Item row par **Movements** dabayein ya sidebar se **"Stock Movements"** kholein.
- Yahan item ka mukammal tareekh-war audit trail milega:
  - `+ In`: Goods Receipt (PO number ke sath).
  - `- Out`: POS Counter Sale (Bill / Invoice number ke sath).
  - `+ In / - Out`: Customer Return ya Stock Adjustment.

---

### 8.4 Expiry Report (30, 60, 90 Din Ki Expiry Monitoring)

Pharmacy aur Grocery Store ke liye yeh **nihayat zaroori** screen hai:
- Sidebar se **"Expiry Report"** kholein.
- Filter buttons: `30 Days`, `60 Days`, `90 Days`.
- System foran list nikal kar batayega ke aglay 1 se 3 mahino mein konse batch expire hone wale hain, unki kitni miqdaar baqi hai aur kitne lakh rupay ka stock phansa hua hai.
- **Karobari Faida**: Expiry aane se pehle distributor ko return chalan bhej kar credit note / wapsi li ja sakti hai.

---

### 8.5 Test Checklist (Inventory Module Test Karein)

1. ☐ **Stock Verification Test**:
   - `Inventory` screen kholein.
   - Step 6 mein receive kiya gaya item `Test Panadol Tablet` dhoondein.
   - Tasdeeq karein ke iska Current Stock **`50`** nazar aa raha hai.
2. ☐ **Damage Stock Adjustment Test**:
   - `Test Panadol Tablet` par `Adjust Stock` dabayein.
   - Type: `Deduct Stock (-)`, Reason: `Damage`, Qty: `2`, Note: `1 pack damaged`.
   - Save dabayein.
   - Tasdeeq karein ke stock 50 se kam ho kar **`48`** ho gaya.
3. ☐ **Stock Movements Audit Test**:
   - Wahi item ka `Movements` page kholein.
   - Check karein ke wahan do lines nazar aa rahi hain:
     1. Pehli line: `+50` (Goods Receipt / Purchase Order).
     2. Doosri line: `-2` (Adjustment / Reason: Damage).
4. ☐ **Expiry Report Test**:
   - `Expiry Report` screen kholein.
   - Check karein ke receive kiye gaye batch aur uski expiry date sahi show ho rahi hai.

---

---

## 9. Step 8: Cash Register aur Shift Management (Galla System)

Dukaan par sab se ahem cheez **Gallay (Cash Drawer) ka hisaab kitab** hota hai taake din ke aakhir par ya cashier badalte waqt aik rupay ka bhi farq na aaye.

Is system mein **Active Shift** ke baghair POS billing screen par sale karne ki ijazat nahi hoti. Yeh intezam is liye hai taake:
1. Subah gallay mein rakhi gayi rezaari (**Opening Float**) system mein record ho.
2. Har sale, payment aur refund ke baad system ko pata ho ke gallay mein kitna cash hona chahiye (**Expected Cash**).
3. Shaam ko cashier ke giney hue asal cash se milan karke kami ya beshi (**Cash Variance / Shortage**) ka foran pata lagaya ja sake.

---

### 9.1 Marhala 1: Subah Shift Kholna (Open Shift)

Jab cashier ya dukaan ka malik subah counter par baithta hai:

1. Sidebar se **"POS"** ya **"Cash Register"** par click karein.
2. Agar pehle se koi shift active na ho, to screen par **"Open Shift & Start Selling"** ka dabba samne aayega:

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Register** | Pehle se selected | Agar pehli baar chala rahe hon to button aayega: `Create Main Counter Register`. Us par click karke pehla register bana lein (e.g., `Main Counter`). |
| **Opening Float \*** | **Haan (Lazmi)** | Gallay mein customer ko baqi paise dene ke liye jo rezaari / note rakhe gaye hain (e.g., `2000.00`). Agar galla bilkul khali hai to `0` likhein. |
| **Notes** | Ikhtiyari | Koi khas wazahat (e.g., "Morning Shift started by Ahmed"). |

3. **"Open Shift & Start Selling"** ka button dabayein.
4. Shift activate ho jayegi aur POS counter billing ke liye khul jayega.

---

### 9.2 Marhala 2: Live Shift Summary Dekhna

Din ke kisi bhi waqt sidebar se **"Cash Register"** (ya POS screen par upar **Shift Summary**) par click karke dekha ja sakta hai:
- **Cashier Name**: Shift kis staff member ke login par chal rahi hai.
- **Opened At**: Shift kis waqt kholi gayi thi aur kitne ghante chal chuki hai.
- **Opening Float**: Subah kitne cash se shuru kiya tha.
- **Cash Sales (+)**: Din bhar mein kitni naqad sale hui.
- **Card / Digital Sales**: Bank card, JazzCash ya EasyPaisa se aayi hui raqam.
- **Customer Khata Payments (+)**: Udhar lene wale gahakon se kitni wasooli aayi.
- **Cash Refunds / Returns (-)**: Wapsi par kitna cash customer ko wapas kiya gaya.
- **Expected Cash in Drawer**: System ke mutabiq is waqt gallay mein kul kitna cash mojood hona chahiye.

---

### 9.3 Marhala 3: Shaam Ko Shift Close Karna (Cash Reconciliation)

Jab shift khatam ho ya cashier doosre bande ko galla handover kar raha ho:

> **Ahem Usool:** Shift har sale ke baad close nahi hoti! Shift sirf din ke aakhir par ya duty khatam hone par close ki jati hai.

1. `Cash Register` screen par jayein aur **"Close Shift"** ka button dabayein.
2. **Close Shift Form** khulega:
   - System **Expected Cash** batayega (masalan `Rs. 25,400.00`).
   - Cashier gallay ke saare note aur sikkay physically haath se ginega.
   - **Actual Cash Counted \*** mein physically gina hua cash darj karein (e.g., `25400.00`).
   - **Notes**: Agar koi farq ho to uski wajah likhein (e.g., "Short Rs. 10 due to change discrepancy").
3. System foran **Variance (Farq)** hisaab karega:
   - **Exact Match (Green)**: Agar Actual aur Expected barabar hon (`Rs. 0.00`).
   - **Surplus (Green)**: Agar gallay mein system se zyada paise nikal aayein (`+Rs. ...`).
   - **Shortage (Red)**: Agar gallay mein se paise kam hon (`-Rs. ...`).
4. **"Confirm & Close Shift"** dabayein.
5. System **Closed Shift Summary Report** generate karega jisay check aur print kiya ja sakta hai.

---

### 9.4 Shift History (Purani Shifts Ka Audit Record)

Sidebar se **"Cash Register"** → **"Shift History"** par click karein:
- Guzishta tamam tareekhon ki shifts ki mukammal list milti hai.
- Kis cashier ne kitni sale ki, opening float kitna tha, closing cash kitna tha aur koi cash chori ya kami to nahi hui, yeh sab kuch history mein hamesha ke liye mehfooz rehta hai.

---

### 9.5 Test Checklist (Shift Management Test Karein)

1. ☐ **Opening Float Ke Sath Shift Kholein**:
   - `POS` screen par jayein.
   - Agar register nahi bana to `Create Main Counter Register` dabayein.
   - Opening Float: `1000.00` darj karein aur `Open Shift & Start Selling` dabayein.
   - Tasdeeq karein ke POS screen open ho gayi aur top bar par register active nazar aa raha hai.
2. ☐ **Live Cash Register Summary Check**:
   - `Cash Register` screen kholein.
   - Tasdeeq karein ke Opening Float `Rs. 1,000.00` aur Expected Cash `Rs. 1,000.00` nazar aa raha hai.
3. ☐ **Close Shift & Exact Match Test**:
   - `Close Shift` dabayein.
   - Expected Cash `1000.00` ke mutabiq Actual Cash `1000` darj karein.
   - Tasdeeq karein ke variance `Rs. 0.00 (Exact Match)` show ho raha hai.
   - `Confirm & Close Shift` dabayein aur tasdeeq karein ke shift kamyabi se close ho gayi.
4. ☐ **Shift History Test**:
   - `Shift History` kholein aur check karein ke abhi close ki gayi shift list mein record ho chuki hai.

---

---

## 10. Step 9: POS (Point of Sale Counter & Thermal Receipt Printing)

POS counter dukaan ka **markazi hissa** hai jahan customer ko tez tareen raftaar se bill bana kar diya jata hai.

Is screen par cashier ko keyboard shortcuts, barcode scanner, multi-payment aur bill hold karne ki poori sahoolat milti hai.

**Kholne ka tareeqa:**
Sidebar / Menu se **"POS"** par click karein. (Yaqeen banayein ke Step 8 ke mutabiq Shift open ho).

---

### 10.1 POS Screen Ka Naqsha (Layout)

POS screen teen hisson par mushtamil hai:
1. **Top Bar**:
   - **Barcode / Product Search Bar**: Click karein ya `F2` dabayein aur barcode scan karein.
   - **Customer Button**: `F4` dabayein ya customer chunein (Walk-in ya Udhar customer).
   - **Held Orders Icon**: Hold kiye gaye bills dekhne ke liye.
   - **Active Register & Shift Info**: Gallay ki live maloomat.
2. **Left / Center (Product Grid Area)**:
   - Dukaan ke items tasveeron aur qeemat ke sath cards ki shakal mein nazar aate hain.
   - Category wise tabs hain taake screen par tap karke bhi item cart mein shamil ho sake.
3. **Right Side (Cart Panel / Bill List)**:
   - Shamil kiye gaye items ki list, miqdaar (Qty), rate aur kul raqam.
   - Subtotal, Tax aur Grand Total.
   - **Pay Button**: Payment lene ke liye (`F8` shortcut).

#### Ahem Keyboard Shortcuts:
- **`F2`**: Barcode search box par focus karna.
- **`F4`**: Customer chunna (Khata select karna).
- **`F8`**: Payment screen kholna.
- **`ESC`**: Cart saaf karna ya dialog band karna.

---

### 10.2 Cart Mein Items Shamil aur Manage Karna

- **Barcode Scanner Se**: USB handheld scanner se item ke pack par scan karein. Item foran cart mein 1 qty ke sath shamil ho jayega. Dobara scan karne se qty 2 ho jayegi.
- **Screen Par Click Karke**: Grid mein kisi bhi item card par tap karein.
- **Quantity Tabdeel Karna**: Cart mein item ke sath `+` aur `-` ke buttons se miqdaar barhayen ya kam karein.
- **Item Khatam Karna**: Cart mein item ko baayen taraf swipe karein ya trash icon dabayein.
- **Discount Lagana**: Cart panel mein Discount button se poore bill par percentage ya fixed raqam ka discount lagayein.

---

### 10.3 Hold Sale (Gahak Ke Ruknay Par Bill Park Karna)

Agar koi customer counter par saaman chhor kar mazeed cheez lene chala jaye ya wallet dhoondh raha ho:
1. Cart ke upar **"Hold Sale"** ka button dabayein.
2. Order ka label likhein (e.g., `Gahak 1`) aur Save karein.
3. Cart foran khali ho jayegi aur aap aglay customer ka bill banana shuru kar sakte hain.
4. Jab purana customer wapas aaye, to upar **"Held Orders"** icon dabayein aur us order par **"Resume"** click karein. Poora bill wapas samne aa jayega!

---

### 10.4 Payment Modal aur Mukhtalif Tareeqay (Multi-Payment)

Jab saare items cart mein aa jayein to **"Pay"** button (`F8`) dabayein. Aik advance payment modal khulega:

System mandarja zail 6 payment tareeqon ko support karta hai:

| Payment Method | Wazahat aur Istemal |
|---|---|
| **Cash (💵)** | Naqad payment. Agar customer ne bill se zyada note diya (masalan bill Rs. 350 hai aur note Rs. 500 ka diya), to system screen par bara bara **Change / Wapas Rezaari (Rs. 150)** dikhayega taake cashier se hisaab mein ghalti na ho. |
| **Card (💳)** | POS machine (Debit/Credit Card) se payment. Reference number likha ja sakta hai. |
| **Easypaisa (📱)** | Easypaisa QR code ya mobile transfer. |
| **JazzCash (📱)** | JazzCash merchant ya till ID payment. |
| **Bank Transfer (🏦)** | Direct bank account mein transfer. |
| **Credit / Udhaar (📝)** | **Sirf us waqt active hota hai jab F4 se saved customer chuna gaya ho.** Agar customer ki credit limit khatam ho chuki ho to system udhar block kar dega. |

> **Split Payment (Aadha Cash, Aadha Digital ya Udhar):**
> Aap aik hi bill mein do tareeqay mila sakte hain. Masalan Rs. 1000 ke bill mein customer ne Rs. 400 Cash diya aur baqi Rs. 600 Card ya Udhar par karwaya.

#### Expired Stock Protection Warning:
Agar ghalti se shelf par koi aisa batch reh gaya ho jiski expiry date guzar chuki hai aur cashier use scan kare, to system foran laal alert dega:
*"Expired stock in this sale"*. Yeh pharmacy aur food marts ko ghalat dawa bechne ke qanooni jurmanay se mehfooz rakhta hai.

---

### 10.5 Thermal Receipt Print Karna (Bill Slip)

Payment complete hote hi **Receipt Preview Screen** samne aati hai:
- 80mm ya 58mm standard thermal receipt format.
- Dukaan ka naam, branch, phone, receipt number, cashier ka naam aur date/time.
- Items ki list, miqdaar, rate, discount aur tax.
- Payment ka tareeqa, wasool shuda raqam aur wapas ki gayi rezaari (Change).
- **Direct Print**: Thermal ESC/POS USB / Bluetooth printer par aik click mein slip print karein.
- **PDF / Share**: WhatsApp ya email ke zariye customer ko digital receipt bhejein.

---

### 10.6 Test Checklist (POS Billing Test Karein)

1. ☐ **Cash Sale & Change Calculator Test**:
   - POS screen par `Test Panadol Tablet` cart mein shamil karein (Qty: 2, Rate: Rs. 15.00, Total: Rs. 30.00).
   - `Pay` dabayein. Method: `Cash` chunein.
   - Cash entered mein `50` likhein.
   - `Complete Sale` dabayein.
   - **Tasdeeq**: Screen par green rang mein **"Give Change: Rs. 20.00"** ka wazeh dialog aana chahiye.
2. ☐ **Receipt Preview Test**:
   - Done dabane par Thermal Receipt preview khulna chahiye jis par dukaan ka naam, item ki tafseel aur Rs. 30.00 total darj ho.
3. ☐ **Stock Deduction Test**:
   - `Inventory` screen par ja kar check karein:
   - **Tasdeeq**: Stock 48 se kam ho kar **`46`** ho chuka hai (sale hone par stock khud kam ho gaya).
4. ☐ **Cash in Hand Check**:
   - `Cash Register` screen kholein.
   - Tasdeeq karein ke Expected Cash `Rs. 1,000.00` se barh kar **`Rs. 1,030.00`** ho gaya hai.
5. ☐ **Hold & Resume Order Test**:
   - Cart mein koi item daalein. `Hold Sale` dabayein.
   - Cart khali ho gayi. Phir `Held Orders` dabba khol kar use `Resume` karein: item wapas cart mein aa jana chahiye.
6. ☐ **Udhar Sale (Credit) Test**:
   - Cart mein item daalein. `F4` se `Test Ali Customer` chunein.
   - `Pay` mein `Credit (Udhaar)` select karein aur complete karein.
   - Tasdeeq karein ke Customer Ledger mein udhar khata barh gaya.

---

---

## 11. Step 10: Sales History aur Returns (Refunds / Exchange)

Karobar mein sales ke baad do ahem zarooratein paish aati hain:
1. Kisi purani sale ka record check karna ya receipt **dobara print (Reprint)** karna.
2. Customer ka kharida hua saaman wapas (**Return**) karna ya badalwana aur cash/khata wapas (**Refund**) karna.

**Kholne ka tareeqa:**
Sidebar / Menu se **"Sales"** par click karein.

---

### 11.1 Sales History aur Receipt Reprint

Sales table mein tamam purani transactions ka mukammal record hota hai:
- **Invoice #**: Receipt ka unique number.
- **Date / Time**: Kis waqt sale hui.
- **Customer**: Walk-in ya registered customer ka naam.
- **Cashier**: Kis staff ne bill banaya.
- **Products**: Biki hui items ki list.
- **Payment Method**: Cash, Card, ya Udhar.
- **Total Amount**: Kul raqam.
- **Status**: `Completed`, `Partially Returned`, ya `Fully Returned`.

#### Receipt Dobara Print Karna:
1. Kisi bhi invoice par click karke uski **Sale Details** kholein.
2. Upar **"Reprint Receipt"** ka button dabayein.
3. Thermal printer se wahi bill dobara nikal aayega.

---

### 11.2 Customer Return / Wapsi (Process Return)

Agar customer koi cheez wapas karne aaye:

1. `Sales` list mein ja kar search box mein customer ki **Invoice #** type karein aur sale kholein.
2. Sale Detail screen par upar **"Process Return"** ka button dabayein.
3. **Process Return Screen** khul jayegi:

#### 1. Return Items (Kiya wapas ho raha hai?):
- System original bill ke saare items dikhayega aur batayega ke customer ne kitne khareede the.
- **Partial Return (Juzwi Wapsi)**: Agar customer ne 5 pieces liye the aur sirf 2 wapas kar raha hai, to `Return Qty` mein `2` likhein.
- **Full Return**: Agar poora item wapas kar raha hai to **"Return All"** dabayein.

#### 2. Return Reason (Wapsi Ki Wajah):
Dropdown se wajah chunein:
- `Defective` (Kharab / Nuqs)
- `Wrong Item` (Ghalat cheez chali gayi)
- `Customer Changed Mind` (Gahak ka irada badal gaya)
- `Damaged` (Toota hua)
- `Other` (Deegar wajah - sath Notes likhein)

#### 3. Refund Method (Paise Kaise Wapas Kiye?):
System khud-ba-khud **Total Return Amount** calculate karega (masalan Rs. 30.00).
Neeche refund ka tareeqa chunein:
- **Cash**: Gallay se naqad paise wapas kiye.
- **Card / Digital**: Online wapsi.
- **Customer Khata (Credit)**: Agar customer udhar wala tha to uske khate se yeh raqam kam kar di jati hai.

4. **"Submit Return"** ka button dabayein.

#### System Ke Andar Khud Kya Tabdeeli Hogi:
- ✔ Wapas kiye gaye pieces **Inventory / Stock mein khud wapas shamil** ho jayenge.
- ✔ Agar Cash wapsi hui, to current shift ke gallay (**Expected Cash**) se utni raqam kam ho jayegi.
- ✔ Original sale ka status `Partially Returned` ya `Fully Returned` ho jayega.
- ✔ Return slip print ho kar audit record ban jayegi.

---

### 11.3 Returns Audit List

Sidebar se **"Returns"** kholein:
- Dukaan par ab tak hone wali tamam wapsiyon ka audit record yahan mojood rehta hai: kis tareekh ko, kis bill se, kis wajah se kitna maal aur raqam wapas hui.

---

### 11.4 Test Checklist (Sales & Returns Test Karein)

1. ☐ **Invoice Search & Details Test**:
   - `Sales` list kholein.
   - Step 9 mein ki gayi pehli sale ki Invoice # search box mein likhein.
   - Row par click karke details dekhein aur check karein ke items aur payments theek hain.
2. ☐ **Partial Return Test (Aadhi Wapsi)**:
   - Sale Detail screen par `Process Return` dabayein.
   - Khareede gaye 2 pieces mein se `Return Qty`: `1` likhein.
   - Reason: `Customer Changed Mind` chunein.
   - Refund Method: `Cash` chunein (Rs. 15.00).
   - `Submit Return` dabayein.
3. ☐ **Stock Wapas Aane Ka Test**:
   - `Inventory` screen par ja kar check karein:
   - **Tasdeeq**: Stock 46 se wapas barh kar **`47`** ho chuka hai!
4. ☐ **Cash Drawer Refund Deduction Test**:
   - `Cash Register` screen kholein.
   - **Tasdeeq**: Expected Cash `Rs. 1,030.00` se kam ho kar **`Rs. 1,015.00`** ho gaya hai (Refund minus ho gaya).
5. ☐ **Original Sale Status Check**:
   - `Sales` list mein check karein ke us sale par `Partially Returned` ka badge lag chuka hai.

---

---

## 12. Step 11: Expenses (Dukaan ke rozmarra ke kharche)

Dukaan ki asal kamai (Net Profit) sirf sales se nahi banti, balkay sales mein se **Dukaan ke kharche (Expenses)** nikaal kar banti hai.

Agar chai, bijli ka bill, dukaan ka kiraya ya staff ki tankhwah system mein darj na ho, to mahine ke aakhir par software aap ko ghalat munafa dikhayega aur gallay mein cash ka farq aayega.

**Kholne ka tareeqa:**
Sidebar / Menu se **"Expenses"** par click karein.
Upar total kharche, mahine ka total aur **"Add Expense"** ka button nazar aayega.

---

### 12.1 Expense Categories (Kharchon Ki Taqseem)

Kharche darj karne se pehle unki categories mojood hoti hain:
- **Built-in / Pehle se mojood categories**:
  - `Rent` (Dukaan ka kiraya)
  - `Electricity / Utilities` (Bijli, paani, gas ke bill)
  - `Salary / Wages` (Staff ki tankhwah ya rozana dehari)
  - `Tea & Refreshment` (Dukaan ki chai, paani aur biscuits)
  - `Transport / Delivery` (Maal lane ka kiraya / delivery boy petrol)
  - `Maintenance / Repairs` (Dukaan ki marammat, AC service waghera)
  - `Other` (Deegar mutafarriq kharche)

#### Nayi Category Banana:
Form par `Category` ke sath **"New Category"** ka button dabayein:
- Category Name likhein (masalan `Internet & Software` ya `Packaging Bags`) aur Save karein.

---

### 12.2 Naya Kharcha Darj Karna (Expense Form)

Toolbar par **"Add Expense"** dabayein. Aik asaan form khulega:

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Category \*** | **Haan (Lazmi)** | Dropdown se category chunein (e.g., `Tea & Refreshment`). |
| **Supplier** | Ikhtiyari | Agar kisi makhsoos vendor ka bill ho (masalan `K-Electric` ya `Landlord`). |
| **Amount \*** | **Haan (Lazmi)** | Kharch ki gayi raqam (e.g., `150.00`). |
| **Tax Amount** | Ikhtiyari | Agar bill par tax laga ho (warna `0`). |
| **Expense Date \*** | Default: Aaj | Jis tareekh ko kharcha hua (Calendar se badal sakte hain). |
| **Description \*** | **Haan (Lazmi)** | Wajah ya tafseel likhein (e.g., `Dukaan ki subah ki chai aur samosay`). |

---

### 12.3 Payment Section (Gallay Se Cash Kaatna)

Form ke neeche **"Record Payment Now"** ka switch mojood hai:

- **Switch ON (Payment ho chuki hai)**:
  - **Payment Method**: `Cash`, `Card`, `Bank Transfer`, `Wallet (JazzCash/Easypaisa)`, ya `Cheque`.
  - **Payment Amount**: Kul raqam (default amount ke barabar hoti hai).
  - **Reference No**: Agar bank cheque ya online transaction ho.
  - **Ahem Karobari Asar**: Agar aap **Cash** chunte hain, to system current shift ke gallay (**Expected Cash in Drawer**) se yeh raqam khud-ba-khud minus kar dega! Is se shaam ko galla gintay waqt chai ya petrol ke paison ka farq nahi aayega.
- **Switch OFF (Unpaid Kharcha)**:
  - Agar kiraya ya bijli ka bill abhi dena baqi ho (Payable).

**Save Action:** Neeche **"Save Expense"** dabayein. Kharcha save ho kar list mein shamil ho jayega.

---

### 12.4 Test Checklist (Expenses Module Test Karein)

1. ☐ **Chai Ka Kharcha Darj Karein (Cash Outflow)**:
   - `Expenses` → `Add Expense` kholein.
   - Category: `Tea & Refreshment`, Amount: `150.00`.
   - Description: `Daily tea for staff`.
   - `Record Payment Now` ON rakhein aur Method: `Cash` chunein.
   - `Save Expense` dabayein.
2. ☐ **Cash Register Check (Gallay Se Rakam Kam Hone Ka Test)**:
   - `Cash Register` screen kholein.
   - **Tasdeeq**: Expected Cash `Rs. 1,015.00` se kam ho kar **`Rs. 865.00`** ho chuka hai (Rs. 150 drawer se kaat liye gaye).
3. ☐ **Nayi Category Banane Ka Test**:
   - `Add Expense` khol kar `New Category` dabayein.
   - Name: `Stationery & Packaging` likh kar save karein aur verify karein ke dropdown mein select ho gaya.
4. ☐ **Khali Field Validation Test**:
   - Amount aur Description khali chhor kar save dabayein: system ko *"Amount is required"* aur *"Description is required"* ka error dena chahiye.
5. ☐ **Expense List & Filter Test**:
   - Expenses list mein check karein ke abhi darj kiya gaya kharcha `Paid` badge ke sath show ho raha hai.

---

---

## 13. Step 12: Reports aur Karobari Munafa/Nuqsan Analytics

Aik kamyab karobar andazay par nahi, balkay **pukhta numbers aur reports** par chalta hai.

Reports module dukaan ke malik ko batata hai ke:
- Asal mein kitna munafa (**Net Profit**) hua?
- Konsa item sab se zyada bik raha hai aur konsa maal dukaan mein phansa hua hai (**Dead Stock**)?
- Dukaan par sab se zyada rush kis waqt hota hai (**Peak Hours**)?
- Cashiers ki karardagi kaisi hai aur koi ghalti ya ghula-mula to nahi ho raha (**Security Audit**)?

**Kholne ka tareeqa:**
Sidebar / Menu se **"Reports"** par click karein.
Upar date filters (Today, Yesterday, Last 7 Days, This Month, Custom Date) aur Excel export ka option milega.

---

### 13.1 Reports Ke 5 Ahem Tabs

Screen par 5 ahem tabs mojood hain:

#### 1. Sales Tab (Farokht Ka Jaiza):
- **Gross & Net Sales**: Kul biki hui raqam, discounts aur returns nikaal kar asal sale.
- **Today vs Yesterday**: Kal ke muqablay mein aaj kitni behtar ya kam sale hui.
- **Sales Trend Graph**: Rozana ki sale ka graph.
- **Payment Method Breakdown**: Donut chart jo batata hai ke kitne feesad sale Cash hui aur kitne feesad Card ya Digital Wallet se aayi.
- **Cashier Performance**: Har cashier ne kitne bills banaye aur kitni sale generate ki.
- **Branch Comparison**: Agar aik se zyada dukaanein hon to branches ka aapas mein muwazna.

---

#### 2. Products Tab (Maal aur Dead Stock Analytics):
- **Top Products**: Dukaan ke top bikne wale 10 items (Volume aur Revenue dono ke hisaab se).
- **Category Performance**: Kis category (masalan Medicines, Groceries ya Fast Food) se sab se zyada paisa banta hai.
- **Dead Stock / Slow Moving**: Woh items jo mahino se shelf par paray hain aur bik nahi rahe. Malik in par discount offer chala kar phansa hua paisa nikaal sakta hai.
- **Stock Valuation**: Dukaan mein mojood kul stock ki kharid qeemat (Purchase Value) aur bechne wali qeemat (Retail Value).

---

#### 3. Financial Tab (Profit & Loss Statement - Munafa / Nuqsan):
Yeh dukaan ke malik ke liye **sab se ahem financial statement** hai:
- **Total Revenue**: Kul biki hui raqam.
- **Cost of Goods Sold (COGS)**: Biki hui cheezon ki asal kharid qeemat.
- **Gross Profit (Khaam Munafa)**: `Total Revenue - COGS`.
- **Operating Expenses**: Step 11 mein darj kiye gaye dukaan ke kharche (bijli, kiraya, tankhwah, chai).
- **Net Profit (Khaalis Bachat / Asal Munafa)**: `Gross Profit - Expenses`.
- **Tax Summary**: FBR / Sales tax ka hisaab (kitna tax customer se liya aur kitna supplier ko diya).

---

#### 4. Time Analysis Tab (Rush Wale Auqaat):
- **Peak Hours Graph**: 24 ghanton ka graph jo batata hai ke dukaan par sab se zyada rush kis waqt hota hai (e.g., shaam 6:00 se raat 10:00 baje tak).
- **Karobari Faida**: Rush ke auqaat mein counter par extra staff khara karein taake lambi line na lagay.

---

#### 5. Security & Cashier Audit Tab:
- **Price Overrides**: Agar cashier ne counter par kisi item ka rate khud kam kiya ho to uska record.
- **Voided & Cancelled Bills**: Bill banate banate cancel kyun kiya gaya.
- **Cash Register Discrepancies**: Shift close karte waqt gallay se cash kam ya zyada hone ka audit.

---

### 13.2 Test Checklist (Reports Module Test Karein)

1. ☐ **Sales Report Check**:
   - `Reports` → `Sales` tab kholein.
   - Date filter `Today` chunein.
   - Tasdeeq karein ke Step 9 aur Step 10 mein ki gayi sale aur return ke baad Net Sales bilkul durust calculation dikha rahi hai.
2. ☐ **Products & Stock Valuation Test**:
   - `Products` tab kholein.
   - Check karein ke Top Products mein aap ka test item show ho raha hai aur dukaan ki total stock value calculate ho rahi hai.
3. ☐ **Financial / Profit & Loss Statement Test**:
   - `Financial` tab kholein.
   - Profit & Loss statement dekhein:
   - Check karein: `Gross Profit` mein se Step 11 ka chai wala kharcha (`Rs. 150`) minus ho kar sahi `Net Profit` ban raha hai ya nahi.
4. ☐ **Date Range Filter Test**:
   - Date filter se `Last 7 Days` aur `This Month` switch karke dekhein; numbers date ke hisaab se update hone chahiye.
5. ☐ **Excel Export Test**:
   - Upar `Export` button dabayein aur Excel / CSV file download karke check karein.

---

---

## 14. Step 13: Staff Users, Roles aur Permissions Control

Karobar mein sab se badi ghalti yeh hoti hai ke dukaan ke malik (Owner) apna main password cashier ya sales boy ko de dete hain.

Is software mein **Role-Based Access Control (RBAC)** mojood hai taake:
1. Cashier sirf POS screen par bill bana sake aur shift khol/band kar sake.
2. Cashier ko dukaan ka kul munafa (Profit/Loss), kharid qeematein ya purani sales delete karne ka ikhtiyar **na** ho.
3. Agar koi staff dukaan chhor jaye to uska account aik click par **Deactivate** kiya ja sake.

**Kholne ka tareeqa:**
Sidebar / Menu se **"Users"** ya **"Roles"** par click karein.

---

### 14.1 Roles aur Ikhtiyarat (Permissions)

System mein mukhtalif roles tayyar kiye ja sakte hain:
- **Owner (Malik)**: Har setting, report, pricing aur accounts ka mukammal control.
- **Store Manager**: Stock receiving, inventory adjustment aur reports dekhne ka ikhtiyar.
- **Cashier**: Sirf POS counter billing, shift kholna/band karna aur receipt print karna.

Sidebar se **"Roles"** par ja kar aap naya custom role bhi bana sakte hain aur apni marzi ki permissions (masalan: kya cashier discount de sakta hai ya nahi) tick/untick kar sakte hain.

---

### 14.2 Naya Staff Member Banayein (Add User)

Sidebar se **"Users"** par jayein → Upar **"Add Staff Member"** dabayein:

| Field Ka Naam | Zaroori? | Matlab aur Misal |
|---|---|---|
| **Full Name \*** | **Haan (Lazmi)** | Staff ka asal naam (e.g., `Zubair Ahmed`). |
| **Phone \*** | **Haan (Lazmi)** | Staff ka mobile number (e.g., `03121234567`). **Yeh number uska Login ID hoga.** |
| **Password \*** | **Haan (Lazmi)** | Shuruati password jo staff ko bataya jayega (e.g., `Staff@1234`). |
| **Branch** | Dropdown | Staff kis dukaan par kaam karega (e.g., `Main Branch`). |
| **Assigned Roles \*** | Checkbox | Staff ko role dein (masalan `Cashier` par tick karein). |

**Save Action:** **"Create Staff Member"** dabayein. Naya staff user ban kar tayyar ho jayega.

---

### 14.3 Fast Counter Switching (Quick PIN Login)

POS counter par har dafa lamba password type karna mushkil hota hai:
- User banne ke baad uski profile par **"Set PIN"** dabayein.
- 4-digit ka asaan PIN (e.g., `1234`) set karein.
- Cashier POS lock hone par foran sirf 4 digits daba kar counter khol sakta hai.

#### Staff Ko Block / Deactivate Karna:
Agar koi staff chhutti par ho ya dukaan chhor jaye:
- User edit karein aur **"Active"** switch ko **OFF** kar dein.
- Staff usi lamhe system se block ho jayega aur login nahi kar sakega (uska purana record aur audit log mehfooz rahega).

---

### 14.4 Test Checklist (Staff Users & Roles Test Karein)

1. ☐ **Naya Cashier User Banayein**:
   - `Users` → `Add Staff Member` kholein.
   - Name: `Test Cashier Bilal`, Phone: `03451122334`, Password: `Password123`.
   - Role: `Cashier` select karein aur `Create Staff Member` dabayein.
2. ☐ **Cashier Login Test**:
   - Main account se Logout karein.
   - Naye cashier ke phone number aur password se Sign In karein.
   - **Tasdeeq**: Cashier ko sirf POS aur Cash Register nazar aana chahiye; sensitive settings aur financial reports block honi chahiye.
3. ☐ **Quick PIN Set & Login Test**:
   - Cashier profile mein ja kar 4-digit PIN set karein aur PIN se unlock karke dekhein.
4. ☐ **Deactivation Test**:
   - Wapas Owner account se login karein.
   - Cashier ki profile khol kar `Active` switch OFF karein.
   - Cashier wale mobile/browser par check karein: login foran radd ho jana chahiye.

---

---

## 15. Step 14: Settings aur Devices Setup (Printers, Barcode Scanners)

Counter par tez aur professional billing ke liye hardware (Receipt Printer, Barcode Scanner aur Auto-Lock) ki sahi setting zaroori hoti hai.

**Kholne ka tareeqa:**
Sidebar / Menu se **"Settings"** par jayein → Yahan **"Receipt Printer"**, **"Receipt Layouts"** aur **"Security"** ke options milenge.

---

### 15.1 Thermal Receipt Printer Setup

App tamam standard **ESC/POS Thermal Printers** (USB, Network LAN, Wi-Fi ya Bluetooth) ko support karti hai.

`Settings` → **"Receipt Printer"** kholein:

1. **Connected Printer**:
   - Dropdown kholein; aap ke computer ya device se jura hua printer list mein nazar aayega (e.g., `XP-80C`, `Epson TM-T20`, `Black Copper`). Usay select karein.
   - (Agar printer nazar na aaye to sath mojood **Refresh icon** dabayein).
2. **Paper Size**:
   - `80mm Roll` (Bara standard thermal roll - zyada behtar hai).
   - `58mm Roll` (Chhota compact roll).
3. **Automatic Printing (Fast Billing)**:
   - **Direct Silent Printing**: Is switch ko **ON** karein. Sale complete hote hi bina kisi Windows print popup ke foran slip printer se bahar nikal aayegi.
4. **Test Print**:
   - Neeche **"Test Print"** ka button dabayein taake tasdeeq ho sake ke printer theek tarah jura hua hai.
   - Upar **"Save Settings"** dabana na bhoolein.

---

### 15.2 Receipt Layout Editor (Bill Ka Design aur Urdu Text)

`Settings` → **"Receipt Layouts"** kholein:
Aap apni dukaan ke mutabiq bill ka format tayyar kar sakte hain:
- **Shop Logo**: Dukaan ka logo bill ke top par print karne ke liye.
- **Header Details**: Dukaan ka legal naam, branch ka pata aur rabta phone number.
- **Tax / NTN**: Agar tax registered hon to FBR NTN / STRN number.
- **Footer Text (Baqi Hidayat)**: Bill ke aakhir par shukriya ya dukaan ki policy likhein (masalan: *"Kharida hua maal 3 din mein tabdeel ho sakta hai. Dawayi fridge mein rakhein."*).
- **Urdu Nastaleeq Font**: Urdu alfaz (items aur customer naam) thermal printer par bilkul jure hue aur saaf print hote hain.

---

### 15.3 Barcode Scanner Setup (Plug and Play)

- Kisi bhi standard **USB Handheld Barcode Scanner** ko computer ya POS machine ki USB port mein lagayein.
- Iske liye kisi driver ya software ki zaroorat nahi hoti.
- POS billing screen par cursor automatic search box mein rehta hai; scanner se item ka barcode scan karein, item khud-ba-khud cart mein shamil ho jayega.

---

### 15.4 Security & Screen Auto-Lock (Galla Mehfooz Rakhna)

`Settings` → **"Security Settings"**:
- **Idle Screen Lock**: 5 ya 10 minute chunein.
- Agar cashier counter chhor kar washroom ya namaz ke liye jaye aur screen khuli reh jaye, to system mutayyan waqt baad screen ko lock kar dega taake koi doosra banda galla na chhoo sake.
- Wapas aane par cashier apna 4-digit PIN daba kar screen foran unlock kar sakta hai.

---

### 15.5 Test Checklist (Devices & Settings Test Karein)

1. ☐ **Printer Detection Test**:
   - `Receipt Printer` page kholein aur Refresh icon dabayein.
   - Check karein ke aap ka thermal printer dropdown mein show ho raha hai.
2. ☐ **Test Print & Receipt Preview Test**:
   - `Test Print` dabayein: printer se sample slip nikalni chahiye.
   - `Preview` dabayein: screen par thermal roll ka visual preview nazar aana chahiye.
3. ☐ **Direct Silent Printing Test**:
   - Direct Printing ON karke save karein.
   - POS par aik test bill banayein: pay dabate hi bina print dialog ke foran slip nikalni chahiye.
4. ☐ **Barcode Scanner Test**:
   - USB scanner connect karein. POS screen par kisi item ka barcode scan karein; check karein ke item 1 second se kam waqt mein cart mein aa gaya.
5. ☐ **Auto-Lock Test**:
   - Screen ko idle chhor kar dekhein: mutayyan waqt baad PIN lock screen aa jani chahiye.

---

---

## 16. Step 15: Offline Mode aur Local Database Sync Engine

Pakistan ke halaat mein bijli ya internet ka jana aam baat hai. Agar internet jane par dukaan ka counter ruk jaye to customer wapas chala jata hai aur karobar ka nuqsan hota hai.

Is maslay ke hal ke liye is app mein **Local SQLite Database (Drift)** aur **Offline Sync Engine** lagaya gaya hai.

---

### 16.1 Internet Ke Baghair Kaam (Offline Counter Sales)

- **Internet Band Ho Jaye To Kya Hoga?**
  - App band nahi hogi aur na hi counter rukega!
  - Cashier aam halaat ki tarah barcode scan karega, items cart mein daalega, cash/card payment complete karega aur thermal printer se receipt nikal kar customer ko dega.
- **Local Outbox Queue**:
  - Internet na hone ki soorat mein har sale phone/computer ki local memory mein mehfooz ho jati hai aur **Outbox** mein jama hoti rehti hai.
  - Screen par chhota sa badge **"Sync Pending"** ya **"Not Synced"** nazar aane lagta hai.

---

### 16.2 Automatic Cloud Sync (Internet Wapas Aane Par)

Jaise hi Wi-Fi ya mobile internet dobara connect hoga:
1. System ka **Sync Engine** khud-ba-khud background mein chal parega.
2. Tamam pending sales, payments aur stock updates server par upload (**Push**) ho jayengi.
3. Server se naye rates ya settings local app par download (**Pull**) ho jayengi.
4. Screen par green tick **"Cloud Done"** nazar aane lagega, jis ka matlab hai ke aap ka sara data online cloud par 100% mehfooz ho chuka hai.

---

### 16.3 Sync Status Screen (`/sync`)

Sidebar se **"Sync"** par click karein:
- **Last Sync**: Aakhri martaba sync kab hua tha (e.g., `just now`, `2 min ago`).
- **Pending Changes**: Kitni transactions server par jana baqi hain.
- **Failed Items**: Agar internet ki kharabi se koi transaction ruk gayi ho to yahan show hoti hai.
- **"Sync Now" Button**: Kisi bhi waqt foran data sync karne ke liye yeh button dabayein.

> **Bohat Ahem Ehtiyat (Golden Rule of Offline):**
> Jab tak Sync Screen par Pending items `0` na ho jayein aur green "Cloud Done" na aa jaye, us waqt tak app ko **Logout ya Uninstall hargiz na karein**! Warna jo sales internet bandi ke dauran hui theen woh cloud par jaane se pehle zaya ho sakti hain.

---

### 16.4 Test Checklist (Offline Mode & Sync Test Karein)

1. ☐ **Airplane Mode / Internet Band Karne Ka Test**:
   - Device ka Wi-Fi / Mobile Data band karein (ya Airplane mode ON karein).
   - POS screen par jayein: check karein ke screen aam routine ki tarah khul rahi hai.
2. ☐ **Offline Sale Test**:
   - Internet band hone ki haalat mein item cart mein daalein aur Cash sale mukammal karein.
   - **Tasdeeq**: Sale kamyabi se complete ho gayi, receipt preview aa gaya aur cart clear ho gayi.
   - Screen par `Sync Pending` ka badge check karein.
3. ☐ **Local Stock Update Check**:
   - Offline rehte hue bhi dukaan ka local stock kam ho chuka hoga.
4. ☐ **Internet Restore & Auto-Sync Test**:
   - Wi-Fi dobara ON karein.
   - `Sync` screen par jayein aur dekhein:
   - **Tasdeeq**: Pending transaction khud-ba-khud upload ho kar `0` ho gayi aur `Cloud Done` ka green nishan aa gaya!

---

---

## 17. Rozana ka Karobari Routine (Subah se shaam tak)

Is software ko dukan par rozmarra chalane ke liye mandarja zail aam routine apnayein:

### 17.1 Subah Dukaan Kholte Waqt:
1. **System & Devices On Karein**:
   - Computer / Tablet, Thermal Printer aur Barcode Scanner on karein.
   - Wi-Fi / Internet connection verify karein.
2. **POS Khulein aur Shift Open Karein**:
   - Gallay mein mojood rezaari / note ginein (masalan Rs. 2,000).
   - `POS` par ja kar **Opening Float** darj karein aur **Open Shift** dabayein.
3. **Subah Ki Alerts Check Karein**:
   - `Inventory` screen par ja kar **Low Stock** dekhein taake distributor ko order diya ja sake.
   - `Expiry Report` par ja kar 30 din mein expire hone wale items check karein.

---

### 17.2 Din Bhar (Billing aur Routine Kaam):
1. **Counter Sales**:
   - Customer aaye to barcode scan karein ya grid se item chunein.
   - `Pay` dabayein, cash entered likhein, change wapas karein aur thermal slip print karein.
   - Udhar wala customer ho to `F4` se uska naam chunein aur `Credit` par sale karein.
   - Agar customer ruk jaye to bill **Hold** karein aur aglay ko serve karein.
2. **Maal Ki Delivery (Receiving)**:
   - Distributor ka maal aane par chalan se dabbe ginein.
   - `Purchases` mein ja kar PO khol kar **Receive Goods** karein aur asal **Batch & Expiry** darj karke confirm karein.
3. **Dukaan Ke Kharche**:
   - Chai, safai ya petrol ke paise gallay se dein to foran `Expenses` mein darj karke payment method **Cash** rakhein (taake galla barabar rahe).
4. **Udhar Ki Wasooli**:
   - Gahak udhar wapas kare to `Customers` → `Ledger` mein ja kar **Record Payment** karein.

---

### 17.3 Shaam / Raat Dukaan Band Karte Waqt (Closing):
1. **Galla Ginein aur Shift Close Karein**:
   - `Cash Register` screen kholein.
   - Gallay mein mojood tamam cash physically ginein.
   - `Close Shift` dabayein aur gina hua cash darj karein.
   - **Variance Check**: Tasdeeq karein ke `Rs. 0.00 (Exact Match)` hai. Agar koi farq ho to wajah note karein.
   - Closed Shift report print karein aur gallay ki cash drawer lock kar dein.
2. **Data Sync Verify Karein**:
   - `Sync` screen par ja kar check karein ke Pending Changes **`0`** hain aur green **"Cloud Done"** nazar aa raha hai.

---

### 17.4 Haftawar aur Mahana Kaam:
- **Khata Statements**: Mahine ke aakhir par udhar wale customers ko unka ledger statement print ya WhatsApp karein.
- **Suppliers Ko Payment**: Distributors ke unpaid bills check karke unki payment clear karein.
- **Profit & Loss Check**: `Reports` → `Financial` mein ja kar mahine ka kul Net Profit (Khaalis Munafa) aur kharche review karein.
- **Dead Stock Clearing**: Aise items jo bik nahi rahe un par sale ya offer laga kar stock clear karein.

---

## 18. Asal Istemal Se Pehle Aakhri Checklist (Go-Live)

Asal dukan chalane aur software par live billing shuru karne se pehle is checklist par tick karein:

- ☐ **Karobar Ki Maloomat**: Dukaan ka asal naam, branch ka pata, rabta number aur logo settings mein save hain.
- ☐ **Tax & Pricing Settings**: Tax inclusive ya exclusive ki setting aap ke karobar ke mutabiq durust set hai.
- ☐ **Test Data Saaf**: Shuru mein banaye gaye tamam test records (test items, test sales, test bills) check/saaf kar liye gaye hain.
- ☐ **Categories aur Units**: Tamam zaroori categories aur naap-tol ke units (pcs, kg, tab, box) base unit ke sath tayyar hain.
- ☐ **Asal Items Catalogue**: Dukaan ke asal items durust naam, category, base unit, expiry tracking aur barcode ke sath add hain.
- ☐ **Retail Prices Set**: Har product ki bechne wali qeemat (`Pricing` tab) set ho chuki hai.
- ☐ **Asal Suppliers Add**: Tamam distributors/dealers unke phone aur payment terms ke sath system mein darj hain.
- ☐ **Asal Stock Dakhil**: Dukaan mein mojood physical stock Goods Receipt (GRN) ke zariye batch aur expiry ke sath system mein dakhil ho chuka hai.
- ☐ **Udhar Customers**: Purane udhar wale customers apne opening balance aur credit limit ke sath add hain.
- ☐ **Hardware Ready**: Thermal printer connect hai, 80mm/58mm roll par test print nikal chuka hai, aur barcode scanner 1 second mein scan kar raha hai.
- ☐ **Staff Users**: Cashiers aur managers ke alag alag accounts aur quick 4-digit PINs set hain (Owner ka password kisi staff ke paas nahi hai).
- ☐ **Shift Open & Close Test**: Galla kholne, opening float likhne aur shaam ko cash reconcile karke shift close karne ki practice ho chuki hai.
- ☐ **Offline & Sync Check**: Wi-Fi band karke offline sale test ki gayi aur Wi-Fi on hone par automatic sync ho kar `Cloud Done` check kar liya gaya hai.

---

## 19. Agar koi masla aaye to developer ko kaise batayen

Agar software chalate waqt koi masla, error ya ghalti samne aaye to developer ko mandarja zail maloomat ke sath message karein:

### Bhejne Ke Liye Zaroori Maloomat:
1. **Aap Ne Kya Kiya (Steps)**: Masalan: *"Maine POS par Panadol scan kiya aur Pay par Cash select kiya."*
2. **Kya Umeed Thi aur Asal Mein Kya Hua**: Masalan: *"Mujhe receipt print hone ki umeed thi, lekin screen par 'Printer not found' ka error aa gaya."*
3. **Screenshot**: Jab screen par error ya masla nazar aa raha ho to uska saaf screenshot lein.
4. **App Ka Version**: `Settings` screen ke sab se neeche likha hua version number (e.g., `Version 1.0.0`).
5. **Internet Ki Haalat**: Aap us waqt Online the ya Offline the.

### Achhi Report Ki Misaal:
> *"Main 'Purchase Order #12' ko receive kar raha tha. Jab maine 'Confirm Receipt' dabaya to screen par 'Batch number is required' ka error aaya halanke batch number field bhari hui thi. Screenshot attach hai. Version 1.0.0, Wi-Fi online."*














