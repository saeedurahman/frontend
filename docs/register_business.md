# Pharmacy Business Setup Guide

Yeh guide pharmacy demo ko business ke aam workflow ke mutabiq, aik aik qadam mein set up karne ke liye hai. Har step complete hone par progress yahan update hogi.

## Business Workflow

1. Pharmacy business register karna.
2. Medicine aur non-medicine product categories banana.
3. Inventory units banana.
4. Supplier record banana.
5. Product catalogue banana aur har product ki selling price set karna.
6. Supplier ke saath purchase order banana.
7. Goods receive karte waqt received quantity, cost, batch number aur label par di hui expiry enter karna.
8. Inventory aur stock levels verify karna.
9. POS shift khol kar test sale karna.
10. Sale receipt, returns, expenses aur reports verify karna.
11. Shift ke end par cash reconcile karke shift close karna.

Supplier ko product catalogue se pehle banana is demo ke liye munasib hai: is se purchase order mein supplier pehle se available hoga. Product banane ke liye supplier lazmi nahi, lekin stock purchase/receive karne ke liye supplier aur product dono chahiye hote hain.

## Real Pharmacy Ka Rozmarra Workflow

Main pharmacy owner ke taur par software ko is tarah chalata hoon:

1. **Business setup aik martaba:** Business/branch, users, permissions, categories, units aur cash register set karta hoon. Har shipment ya har roz business dobara register nahi hota.
2. **Product catalogue jab naya item rakhna ho:** Agar product pehle se catalogue mein nahi hai to purchase order se pehle uska product record banata hoon—naam, strength/form/pack, SKU/barcode, category, unit aur expiry tracking. Wohi product dobara mangwate waqt naya product nahi banata; purana record select karta hoon.
3. **Supplier record pehle:** Har wholesaler/distributor ko aik martaba supplier ke taur par save karta hoon; order ke waqt us supplier ko select karta hoon.
4. **Purchase order jab stock mangwana ho:** Stock kam hone, reorder level ya expected demand par supplier ko order deta hoon. PO batata hai kya aur kitna mangwaya; PO submit hone se stock abhi inventory mein nahi aata.
5. **Goods aane par receiving:** Delivery aur invoice ko PO se milata hoon. Sirf physically aayi hui quantity receive karta hoon, actual cost enter karta hoon, aur batch/expiry package se note karta hoon. `Confirm Receipt` ke baad hi received quantity stock mein add hoti hai. Kami ya ghalat item ho to actual received amount hi record karta hoon—ordered amount ko zabardasti received nahi mark karta.
6. **Inventory roz monitor:** Inventory screen par current balance aur stock movements dekhta hoon. Purchase receipt ke baad alag se stock adjustment nahi karta, warna double-count ho sakta hai. Adjustment sirf physical stock count aur system balance mein tasdeeq-shuda farq ko reason ke saath correct karne ke liye hoti hai.
7. **Price sale se pehle:** Purchase cost, product ki pack/unit, invoice aur lagu approved pricing ke mutabiq retail price set karta hoon. Naya item POS mein bechne se pehle price, sale availability aur stock dobara check karta hoon.
8. **Shift phir sales:** Har cashier/register shift ke start par drawer ka asal opening float gin kar shift kholta hoon. Active shift ke andar POS sale, payment aur receipt record hoti hai; sale ke baad inventory balance kam hota hai. Shift ko har sale ke baad nahi, shift ke end/handover par close karta hoon.
9. **Shift ke end par hisaab:** Drawer ka cash physically count karta hoon, system ke `Expected Cash` se milata hoon, aur farq ho to dobara count karke wajah note karta hoon. Uske baad shift report aur sales/inventory records review karta hoon.
10. **Yahi cycle dobara:** Sales aur stock dekh kar zaroorat par reorder karta hoon. Har batch ki expiry package se verify karta hoon; expired/near-expiry stock ko apni pharmacy policy aur lagu qawaneen ke mutabiq handle karta hoon.

**Is demo ki app mapping:** Product record PO se pehle banta hai; PO order hai, receiving stock add karti hai; Inventory balance/movements dikhati hai; price sale se pehle set hoti hai; POS ke liye active shift zaroori hai. App ki Inventory/Stock Movements lists batch/expiry columns nahi dikhati, is liye unhein wahan verify karne ka dawa na karein.

## Progress

- [x] Pharmacy business register: `Sehat Pharmacy Demo`
- [x] Pharmacy product categories banana
- [x] Inventory units banana
- [x] Supplier banana
- [x] Pehla product catalogue mein banana
- [x] Product ki retail price set karna
- [x] Purchase order submit karna
- [x] Batch/expiry ke saath demo goods receive karna
- [x] Inventory verify karna
- [x] POS sale test karna
- [x] Receipt aur sale record verify karna
- [x] Cash reconcile karke shift close karna
- [x] Closed shift report verify karna
- [x] Mazeed pharmacy demo products banana
- [ ] Mazeed products ka supplier purchase order banana
- [ ] Receipt, returns aur reports verify karna

## Step 1: Business Register

Business ka naam `Sehat Pharmacy Demo` rakh kar Pharmacy business type select ki gayi.

**Wajah:** Business type ke mutabiq application ka workspace configure hota hai.

## Step 2: Product Categories

Pharmacy ke liye categories banayi gayin. Medicines ke andar `Prescription (Rx)` aur `OTC Medicines` subcategories rakhi ja sakti hain; doosri misaalen `Vitamins & Supplements`, `Medical Supplies & Devices`, aur `Personal Care` hain.

**Wajah:** Categories catalogue ko munazzam aur products ko dhoondhna asaan banati hain.

## Step 3: Inventory Units

Product form ke `Base Unit` dropdown mein koi unit available nahi thi, is liye zaroori units create ki gayin. Categories aur units apne dialog ke `Save` se alag save hoti hain; product form band karne se woh delete nahi hotin.

**Wajah:** Har product ka stock aur sale aik wazeh unit mein record hona chahiye. `Strip` ya `Box` tabhi add karein jab unki piece-count conversion app mein configure/verify ho; warna receiving aur sale aik hi base unit mein rakhein.

## Step 4: Supplier — Agla Qadam

1. Sidebar/menu mein `Suppliers` kholo.
2. `Add Supplier` dabao.
3. Demo supplier ke tamam fields is tarah bharo:
   - `Name *`: `Demo Pharma Distributors`
   - `Contact Person`: `Demo Sales Representative`
   - `Email`: `sales@demo-pharma.example` (demo address; `.example` reserved hai)
   - `Phone`: `00000000000` (sirf wazeh demo placeholder, kisi supplier ka asal number nahi)
   - `Tax ID`: `DEMO-NOT-A-REAL-NTN` (sirf demo placeholder, valid tax number nahi)
   - `Address`: `Demo Market, Main Road` (fictional demo address)
   - `City`: business register karte waqt select kiya hua shehar
   - `Payment Terms (days)`: `30`
4. `Create Supplier` dabao aur supplier list mein record verify karo.

**Wajah:** Supplier pehle register karne se aglay qadam mein purchase order usi supplier ke naam par banega. Supplier ki asal contact/tax details sirf authorized business setup mein sahi source se enter karein.

**Demo data ehtiyat:** Upar diye gaye supplier contact, address aur tax ID placeholders sirf demo ke liye hain, haqeeqi business details nahi. Live business mein inhein supplier ke tasdeeq-shuda records se badlein. Is guide mein koi dawa ki dose ya patient-use mashwara nahi diya ja raha. Live pharmacy mein product, batch aur expiry ki maloomat authorized source aur manufacturer pack/label ke mutabiq honi chahiye; batch number ya expiry kabhi andazay se na bharein. Pharmacy ke liye lagu license aur regulatory requirements alag se poori karein.

## Step 5: Pehla Product — Complete

Pehla demo product `Demo Paracetamol 500 mg Tablet` save ho chuka hai.

### Details tab

- `Product Name *`: `Demo Paracetamol 500 mg Tablet`
- `SKU`: `PH-DEMO-001`
- `Category`: `OTC Medicines` (agar yeh category banayi ho; warna apni banayi hui medicines category select karo)
- `Brand`: `Optional` — demo mein `None` select karo.
- `Base Unit *`: `Tablet (tab)` (ya unit list mein banaya hua isi naam ka unit)
- `Product Type *`: `Standard`
- `Tracking Type *`: `Expiry`
- `Shelf Life (days)`: `Optional` — expiry date receiving ke waqt supplier/manufacturer pack se enter hogi; shelf life ka andaza na lagao.
- `Description`: `Pharmacy demo inventory item; pack details receiving par verify karni hain.`
- `Product image`: `Optional`

### Stock & Availability card

- `Is Sellable`: ON
- `Is Purchasable`: ON
- `Min Stock Level`: `Optional` — pehli demo item ke liye abhi set na karo.
- `Max Stock Level`: `Optional` — pehli demo item ke liye abhi set na karo.

### Variations aur Barcodes tabs

- Variation: default variation rehne do; form skip karne par yeh khud banegi.
- Barcode: `Optional` — asal pack barcode available ho to baad mein scan/enter karna; demo number invent na karo.

Product create form mein retail price tab nahi hoti. Product save karne ke baad purchase ke invoice cost aur lagu pricing rules ke mutabiq price set karenge. Abhi stock adjustment mat karo—stock purchase order receive karne par add hoga.

**Wajah:** Product record purchase order ke liye zaroori hai. `Expiry` tracking select karne se expiry wali inventory ka workflow use hoga; asal batch number aur expiry goods receive karte waqt pack/invoice se li jayegi. Demo product name sirf software test ke liye hai, dawa ke istemal ya dose ki hidayat nahi.

## Step 6: Purchase Order — Complete

1. Sidebar se `Purchases` kholo aur `New Purchase Order` dabao.
2. `Supplier *`: `Demo Pharma Distributors` select karo.
3. `Expected Date`: `Optional`.
4. `Notes`: `Optional`.
5. `Line Items` mein pehli row:
   - `Product`: `Demo Paracetamol 500 mg Tablet`
   - `Variation`: product select karne ke baad default variation auto-select honi chahiye; usay selected rehne do.
   - `Ordered Qty`: `100` (demo stock tablets ki tadaad)
   - `Cost/Unit`: `5.00` (sirf software demo ke liye fictional cost; asli purchase mein supplier invoice ki per-tablet cost use karein)
   - `Tax %`: `0` (sirf fictional demo transaction; haqeeqi purchase mein supplier invoice aur lagu tax rules ke mutabiq rate dakhil karein)
6. Totals mein demo grand total `Rs. 500.00` verify karo.
7. `Save & Submit` dabao, phir Purchase Orders list mein order submitted/ordered nazar aane ki tasdeeq karo.

**Wajah:** Purchase order supplier ko bheji jane wali order aur expected stock ko record karta hai. Is se abhi inventory mein stock add nahi hota. Stock goods receive karte waqt add hoga; usi receiving screen par asal batch number aur pack par likhi expiry enter karenge.

**Demo data ehtiyat:** `5.00` per unit aur `0` tax fictional software-test values hain, market price ya tax advice nahi. Live purchase mein supplier invoice ki exact cost/tax use karein. Batch number aur expiry receiving ke waqt asal pack/invoice se hi dakhil karein—unhein invent na karein.

## Step 7: Goods Receipt — Complete

1. `Purchases` list mein submitted order kholo. Order ka status `Submitted`/`In Progress` hona chahiye.
2. Order detail ke `More` menu se `Receive Goods` kholo.
3. Receipt header:
   - `Received Date`: aaj ki date default hogi; demo mein isi ko rehne do.
   - `Supplier Invoice No`: `Optional`
   - `Notes`: `Optional`
4. `Demo Paracetamol 500 mg Tablet` ki line mein:
   - `Qty Receiving`: `100`
   - `Cost/Unit`: `5.00`
   - `Batch No`: `DEMO-TEST-ONLY-001`
   - `Expiry`: `2028-12-31`
5. `Confirm Receipt` dabao. Success ke baad PO detail/status mein received stock aur completed order verify karo.

**Demo data ehtiyat:** Batch `DEMO-TEST-ONLY-001` aur expiry `2028-12-31` sirf software demo ke liye synthetic values hain; yeh kisi asli dawa/lot ki maloomat nahi aur dispensing ke liye kabhi use na hon. Haqeeqi pharmacy mein sirf physically received pack ka batch aur manufacturer expiry enter karein. `Qty Receiving` remaining quantity se zyada na ho.

**Wajah:** Goods receipt se inventory mein waqai received quantity post hoti hai, aur lot-level batch/expiry record hota hai. Sirf PO submit karne se stock increase nahi hua tha.

## Step 8: Retail Price — Complete

1. `Products` list kholo aur `Demo Paracetamol 500 mg Tablet` ko search karo.
2. Row par `Edit` icon dabao.
3. `Pricing` tab kholo.
4. `Price *`: `Rs. 6.00` (sirf software demo value; is product ki base unit `Tablet` hai).
5. `Min Qty (optional)`: `Optional`.
6. `Set Price` dabao aur `Current retail price` mein `Rs. 6.00` dikhne ki tasdeeq karo.

**Wajah:** Product create karte waqt retail price set nahi hoti. Default price list par price set hone se POS ko item ki price milti hai, warna cashier ko sale ke waqt manually price enter karni padegi.

**Demo data ehtiyat:** `Rs. 6.00` fictional test price hai, dawa ki market price ya pricing advice nahi. Haqeeqi pharmacy mein sirf lagu approved retail price aur sahi pack/unit conversion ke mutabiq price set karein. Agar `Pricing` tab na dikhe to apne business admin se price-manage permission check karwayein.

## Step 9: Inventory Verification — Abhi Ka Qadam

1. Sidebar se `Inventory` kholo.
2. Search mein `Demo Paracetamol 500 mg Tablet` likho.
3. Product ki row mein verify karo:
   - `Current Stock`: `100`
   - `Unit`: `Tablet`
   - Status: `In Stock`
4. Usi row ka `Movements` action kholo. `Stock Movements` mein receiving ka movement, quantity `100`, cost `5.00` aur balance `100` verify karo.

**Wajah:** Is se tasdeeq hoti hai ke submitted PO aur confirmed goods receipt ne inventory balance ko sahi update kiya.

**Note:** Inventory table aur Stock Movements view batch/expiry columns nahi dikhate. Batch/expiry values goods receipt par enter ki gayi thin; in screens mein unhein dobara dikhne ki umeed na rakhein.

## Agla Qadam

Inventory balance theek hai. Agla qadam cash register shift khol kar POS mein demo sale complete karna hai.

## Step 10: POS Sale — Complete

1. `POS` kholo. Agar sale screen par active shift maujood hai to naya shift na kholo.
2. `No Active Shift` aaye to:
   - Register list mein register maujood ho to usay select karo.
   - List khaali ho to `Create Main Counter Register` dabao.
   - `Opening Float *`: `0` (software demo ke liye)
   - `Notes (optional)`: `Optional`
   - `Open Shift & Start Selling` dabao.
3. Product search karke `Demo Paracetamol 500 mg Tablet` ko sale mein add karo; quantity `1` rakho.
4. Cart ke `PAY NOW` button ko dabao. Payment dialog mein `Cash` chuno; cash amount payable total ke barabar rakho. Agar product/tax settings ki wajah se total Rs. 6 se mukhtalif ho to dialog ka dikhaya hua total use karo.
5. `Complete Sale` dabao aur sale complete hone ki tasdeeq karo. Receipt preview aaye to filhal usay dekh kar wapas aao; alag receipt/printer testing aglay steps mein hogi.

**Wajah:** Is se inventory se aik unit deduct hota hai aur active shift ke andar cash sale record hoti hai. Demo se pehle opening float `0` hai, is liye drawer mein cash count bhi zero se shuru hota hai.

**Demo data ehtiyat:** Yeh test transaction fictional product, stock, price aur supplier details par hai. Isay real customer sale ya dawa dispense karne ke liye use na karein.

## Step 11: Receipt aur Sale Record Verify Karna — Abhi Ka Qadam

1. Sale ke baad khulne wale receipt preview mein `Sale Number`, product, quantity, payment aur total check karo.
2. Abhi `Print Receipt`, `Send on WhatsApp` ya `Save PDF` na chalao; in features ki alag testing baad mein hogi.
3. Sidebar se `Sales` kholo.
4. `Today` filter select karo aur search box mein receipt ka `Sale Number` dhoondo.
5. Sale row ka status `Completed`, product `Demo Paracetamol 500 mg Tablet`, payment `Cash`, aur total receipt se match hona verify karo.
6. Sale row kholo aur detail mein line item/payment dobara check karo.

**Wajah:** Receipt preview aur saved sale record ko compare karne se pata chalta hai ke POS ki transaction sahi record hui hai.

## Agla Qadam

Sale record verify ho gaya. Ab shift summary reconcile karke demo shift close karna hai.

## Step 12: Cash Reconcile aur Shift Close — Complete

1. Sidebar se `Cash Register` kholo; current/open shift ki summary dekho.
2. `Close Shift` dabao.
3. `Expected Cash` amount dekho. Yeh system ka hisaab hai—drawer mein maujood cash gin kar `Closing Cash Count *` mein asal counted amount dakhil karo.
4. `Notes`: `Optional`, jab counted cash expected cash se match kare.
5. Agar software-only demo tha aur koi haqeeqi cash drawer mein nahi rakha, `Closing Cash Count *` mein `0` dakhil karo aur `Notes` mein `Software demo; no physical cash handled` likho. System variance dikhaye to `Yes, close with variance` sirf is demo variance ko confirm karne ke liye dabao.
6. Agar expected aur counted cash match nahi karte, farq dobara gin kar verify karo. Live business mein variance ko chhupane ke bajaye asal amount aur wajah record karo.
7. `Confirm & Close Shift` dabao. `Shift Closed` summary mein cash difference/variance dekho.

**Wajah:** Shift close karne se system ki cash sales aur drawer ka counted cash reconcile hota hai. Demo mein zero cash count software-only test ko sachai se darj karta hai; live counter mein hamesha physically counted cash enter karo.

**Variance ka matlab:** `Variance = Closing Cash Count − Expected Cash`. `0` ka matlab exact match; positive variance `OVER` (drawer mein expected se zyada cash); negative variance `SHORT` (expected se kam cash). Misal: expected Rs. 100 aur counted Rs. 90 ho to Rs. 10 SHORT.

`Yes, close with variance` ka matlab hai mismatch ke bawajood shift ko close karne ki tasdeeq. Yeh market price/rate ka farq nahi aur na hi cash ko khud-ba-khud theek karta hai. Live business mein pehle cash dobara gino, farq ki wajah jaancho aur apni manager/accounting policy ke mutabiq discrepancy record karo; sirf jaanch ke baad close with variance confirm karo.

## Step 13: Closed Shift Report — Complete

1. Agar `Shift Closed` screen abhi khuli hai to `View Full Shift Report` dabao.
2. Agar woh screen band ho chuki hai to `Cash Register` kholo → `Shift History` → `Today`, phir abhi band ki hui shift ki row kholo.
3. Report mein yeh values check karo:
   - `Cash Sales`: completed cash sale ka total.
   - `Expected Cash in Drawer`: opening float aur cash transactions ke baad system ka expected amount.
   - `Counted Cash`: shift close karte waqt enter ki hui asal ginti.
   - `Variance`: Step 12 mein samjhayi hui `OVER`, `SHORT` ya `Exact match` value.
   - `Card Sales`, `Wallet Sales`, `Returns`, `Cash In`, `Cash Out`, `Expenses`: demo mein inka koi transaction na hua ho to `0` honi chahiye.
4. Report ki `Counted Cash` aur `Variance` ko shift close summary se milao. Software-only demo mein physical cash na hone par `SHORT` variance intentional demo record hai; real business mein isay investigate karna zaroori hota.

**Wajah:** Shift report ek jagah par cashier/register, sales, cash movement aur reconciliation ka final record dikhati hai.

## Step 14: Mazeed Pharmacy Products — Complete

Pehla product pehle hi bana hai. Ab neeche diye gaye **12 additional demo products** ko aik aik karke `Products` → `Add Product` se banao. Har product save karne ke baad list par wapas aa kar agla add karo. Agar table mein di hui category aapke business mein nahi milti to uski jagah maujooda `Medicines` category select karo; duplicate category na banao.

### Har product par common fields

- `Product Type *`: `Standard`
- `Tracking Type *`: `Expiry`
- `Track expiry`: ON
- `Shelf Life (days)`: table mein diya hua number (sirf software alert/test value)
- `Brand`: `Optional` — `None` select karo, jab tak demo brand list mein koi brand maujood na ho.
- `Description`: `Synthetic pharmacy demo item for product, purchase, expiry and POS testing only.`
- `Product image`: `Optional`
- `Is Sellable`: ON
- `Is Purchasable`: ON
- `Min Stock Level`: `10` (selected base unit mein)
- `Max Stock Level`: `100` (selected base unit mein)
- `Tax rate`: `Use business default`
- `This item is tax-free`: OFF

### Har product ki unique details

| # | Product Name | SKU | Category | Base Unit | Shelf Life (days) | Variation Name | Variation SKU | Barcode |
|---|---|---|---|---|---:|---|---|---|
| 2 | Demo Ibuprofen 200 mg Tablet | PH-DEMO-002 | OTC Medicines | Tablet (`tab`) | 730 | 1 Tablet | V-PH-DEMO-002 | TEST-PH-002 |
| 3 | Demo Cetirizine 10 mg Tablet | PH-DEMO-003 | OTC Medicines | Tablet (`tab`) | 730 | 1 Tablet | V-PH-DEMO-003 | TEST-PH-003 |
| 4 | Demo ORS Powder Sachet | PH-DEMO-004 | OTC Medicines | Piece (`pc`) | 730 | 1 Sachet | V-PH-DEMO-004 | TEST-PH-004 |
| 5 | Demo Amoxicillin 500 mg Capsule | PH-DEMO-005 | Prescription (Rx) | Capsule (`cap`) | 730 | 1 Capsule | V-PH-DEMO-005 | TEST-PH-005 |
| 6 | Demo Omeprazole 20 mg Capsule | PH-DEMO-006 | Prescription (Rx) | Capsule (`cap`) | 730 | 1 Capsule | V-PH-DEMO-006 | TEST-PH-006 |
| 7 | Demo Metformin 500 mg Tablet | PH-DEMO-007 | Prescription (Rx) | Tablet (`tab`) | 730 | 1 Tablet | V-PH-DEMO-007 | TEST-PH-007 |
| 8 | Demo Amlodipine 5 mg Tablet | PH-DEMO-008 | Prescription (Rx) | Tablet (`tab`) | 730 | 1 Tablet | V-PH-DEMO-008 | TEST-PH-008 |
| 9 | Demo Vitamin C 500 mg Tablet | PH-DEMO-009 | Vitamins & Supplements | Tablet (`tab`) | 730 | 1 Tablet | V-PH-DEMO-009 | TEST-PH-009 |
| 10 | Demo Multivitamin Syrup 120 ml | PH-DEMO-010 | Vitamins & Supplements | Bottle (`btl`) | 730 | 1 Bottle | V-PH-DEMO-010 | TEST-PH-010 |
| 11 | Demo Cough Syrup 100 ml | PH-DEMO-011 | OTC Medicines | Bottle (`btl`) | 730 | 1 Bottle | V-PH-DEMO-011 | TEST-PH-011 |
| 12 | Demo Antiseptic Cream 20 g | PH-DEMO-012 | Medical Supplies & Devices | Tube (`tube`) | 730 | 1 Tube | V-PH-DEM2O-01 | TEST-PH-012 |
| 13 | Demo Hand Sanitizer 100 ml | PH-DEMO-013 | Personal Care | Bottle (`btl`) | 730 | 1 Bottle | V-PH-DEMO-013 | TEST-PH-013 |

### Variations aur barcode fields bhi fill karo

Har product ke `Variations` tab mein aik row add karo:

- `Name`: table ka `Variation Name`
- `SKU`: table ka `Variation SKU`
- `Unit`: us product ke base unit ka symbol
- `Weight (g)`: `Optional`
- `Default`: checked

`Barcodes` tab mein aik row add karo:

- `Barcode`: table ka `Barcode`
- `Type`: `Custom`
- `Variation`: us product ki variation select karo
- `Primary`: checked

`TEST-PH-...` values jaan-boojh kar fake custom codes hain; inhein real product packaging, scanner-based retail ya kisi asli medicine ke barcode ke taur par use na karo.

### Save aur agla kaam

`Save Product` dabao. Product list mein naye product ka naam/SKU nazar aaye to agla item banao. Is step mein stock adjustment ya nayi purchase order mat banao. Agle qadam mein in products ko supplier ke PO mein add karke demo receiving, batch/expiry, stock aur pricing ko bulk mein test karenge.

**Demo data ehtiyat:** Yeh product names, SKUs, barcodes aur `730` din ki shelf life synthetic test data hai—asal manufacturer, product registration, storage condition, expiry ya clinical recommendation nahi. Expiry tracking ka form test karne ke liye receiving screen par sirf clearly synthetic demo batch/date use karo. Is data se real patient ko dawa sell/dispense na karo. Live pharmacy mein exact product identity, pack size, batch aur expiry packaging/supplier ke authentic record se lena.

## Step 15: Mazeed Products ka Purchase Order — Abhi Ka Qadam

Product catalogue mein 12 mazeed items add ho chuke hain. Ab supplier `Demo Pharma Distributors` ko aik combined test PO banao:

1. `Purchases` → `New Purchase Order` kholo.
2. Header ke tamam fields:
   - `Supplier *`: `Demo Pharma Distributors`
   - `Expected Date`: kal ki tareekh (date picker se)
   - `Notes`: `Synthetic software demo order; not a real medicine purchase.`
3. Pehli line pre-filled hogi. `Add Line` daba kar kul 12 line items banao. Har line par product select karo; product select karne par default variation auto-select honi chahiye. Phir neeche di hui `Ordered Qty`, `Cost/Unit`, aur `Tax %` values dakhil karo:

| SKU | Product | Variation | Ordered Qty | Cost/Unit (Rs.) | Tax % |
|---|---|---|---:|---:|---:|
| PH-DEMO-002 | Demo Ibuprofen 200 mg Tablet | 1 Tablet | 10 | 2.00 | 0 |
| PH-DEMO-003 | Demo Cetirizine 10 mg Tablet | 1 Tablet | 10 | 1.50 | 0 |
| PH-DEMO-004 | Demo ORS Powder Sachet | 1 Sachet | 10 | 20.00 | 0 |
| PH-DEMO-005 | Demo Amoxicillin 500 mg Capsule | 1 Capsule | 10 | 8.00 | 0 |
| PH-DEMO-006 | Demo Omeprazole 20 mg Capsule | 1 Capsule | 10 | 5.00 | 0 |
| PH-DEMO-007 | Demo Metformin 500 mg Tablet | 1 Tablet | 10 | 1.25 | 0 |
| PH-DEMO-008 | Demo Amlodipine 5 mg Tablet | 1 Tablet | 10 | 1.00 | 0 |
| PH-DEMO-009 | Demo Vitamin C 500 mg Tablet | 1 Tablet | 10 | 3.00 | 0 |
| PH-DEMO-010 | Demo Multivitamin Syrup 120 ml | 1 Bottle | 10 | 120.00 | 0 |
| PH-DEMO-011 | Demo Cough Syrup 100 ml | 1 Bottle | 10 | 90.00 | 0 |
| PH-DEMO-012 | Demo Antiseptic Cream 20 g | 1 Tube | 10 | 55.00 | 0 |
| PH-DEMO-013 | Demo Hand Sanitizer 100 ml | 1 Bottle | 10 | 45.00 | 0 |

4. `Totals` mein subtotal/grand total `Rs. 3,517.50` verify karo.
5. `Save & Submit` dabao. Purchase Orders list mein order `Submitted`/`In Progress` nazar aana chahiye. **Abhi receive mat karo**; goods receipt agla alag qadam hai.

**Wajah:** Aik PO mein supplier ko bheje gaye tamam products aur quantities ek saath record hote hain. PO submit karna stock ko barhata nahi; receiving screen par jo quantity waqai receive ki jayegi wahi inventory mein add hogi.

**Demo data ehtiyat:** Is table ke tamam costs aur zero tax values synthetic software-test numbers hain, asal wholesale prices/tax advice nahi. Yeh purchase/demo medicines real product ya real dispensing stock nahi hain. Real business mein har line ko actual supplier invoice, exact pack/unit, approved tax treatment aur authentic item identity se match karo. Agar product/variation dropdown mein item nahi milta to usay skip karke error batana—kisi doosre product ko substitute na karna.

## Agla Qadam

PO submit hone ke baad is test order ki goods receipt banayenge; har line ki received quantity, cost, batch aur expiry ko demo data ke taur par enter karke inventory mein stock verify karenge.
