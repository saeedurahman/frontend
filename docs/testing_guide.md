# Testing Guide

## Online Sale

**Test data:** `Test Shop 3` (Grocery) naya aur khaali business hai. Is guide mein `Test Item` product aur ek test sale add hogi; yeh data business mein save rahega.

**Shuru karne se pehle:** `Test Shop 3` mein login hon, sahi branch selected ho, aur sync status `Online` ho.

1. **Shift kholo:** Sidebar se `Cash Register` kholo. Agar active shift nahi hai to `Go to POS` dabao. POS par register setup na ho to `Create Main Counter Register` dabao; phir `Opening Float` mein `0` likh kar `Open Shift & Start Selling` dabao.  
   **Wajah:** Sale cash register shift ke baghair complete nahi ho sakti. Cash Register page se shift kholne ke bajaye POS screen par khulti hai.

2. **Product banao:** Sidebar se `Products` → `Add Product` kholo. `Details` tab ke fields is tarah bharo:
   - `Product Name *`: `Test Item`
   - `SKU`: `TEST-ITEM-001` (optional, magar test item ko dhoondhne mein asani hogi)
   - `Category`: `None` rehne do; Grocery business hone ke bawajood category zaroori nahi. `Brand`: `None` rehne do.
   - `Base Unit *`: `Piece` select karo. Agar list khaali ho to `+ New Unit` dabao, `Unit name` = `Piece`, `Symbol` = `pc`, `Is base unit` tick karke `Save` dabao.
   - `Product Type *`: `Standard`; `Tracking Type *`: `None`.
   - `Description`: `Test grocery item for online sale` (optional); image upload skip karo.
   - `Stock & Availability` card mein `Is Sellable` aur `Is Purchasable` ON rehne do. `Min Stock Level` aur `Max Stock Level` khaali chhoro. Yeh alert thresholds hain, asal stock quantity nahi.
   
   `Variations` tab mein kuch add na karo—default variation khud banegi. `Barcodes` tab bhi khaali chhoro; is test mein barcode ki zaroorat nahi. Ab `Save Product` dabao.  
   **Wajah:** Product Name aur Base Unit zaroori hain. Sellable ON hone se product POS mein becha ja sakta hai; baqi optional fields ko test ke liye bharna zaroori nahi.

3. **Price set karo:** Products list mein `Test Item` ko edit karo → `Pricing` tab kholo → `Price` mein `100` likho → `Set Price` dabao. Agar `Pricing` tab nazar na aaye, aapke user ke paas price manage karne ki permission nahi ho sakti; POS mein product add karte waqt aane wale manual price prompt mein `100` daal sakte hain.  
   **Wajah:** Naya product banate waqt retail price set nahi hoti. POS mein price ke baghair manual price deni padti hai.

4. **Stock add karo:** Sidebar se `Inventory` kholo, `Test Item` dhoondo aur uski row mein `Adjust` dabao. `Add Stock` selected rakho, reason `Count Correction` chuno, quantity `10` daalo, aur `Apply` dabao. `Cost per Unit` test ke liye default `0` rehne dein.  
   **Wajah:** Naye product ka stock zero hota hai; stock ke baghair usay bechne par POS rok sakta hai. Test mein purchase order banane ke bajaye adjustment sab se seedha tareeqa hai.

5. **Sale banao:** POS kholo. Grid ya search se `Test Item` cart mein daalo. `PAY NOW` dabao, `Cash` payment method chuno, aur screen par dikhayi gayi **poori payable amount** cash mein enter karke sale complete karo.  
   **Wajah:** Is se product, stock, price, cash payment aur sale creation ka online flow test hota hai. Tax ya doosri charges hon to payable amount `100` se mukhtalif ho sakti hai.

6. **Print dialog band karo:** Receipt screen par `Print Receipt` dabao; print dialog aaye to `Cancel` karo.  
   **Wajah:** Receipt printing ke bajaye sirf print dialog khulne aur cancel hone ka flow check karna hai.

7. **Sync verify karo:** Sync status chip par click karke Sync page kholo (ya `/sync` par jao), `Sync now` dabao aur result dekho.  
   **Wajah:** Sale server ke saath sync hui hai ya nahi, yahan verify hota hai. Online sync ke baad waiting aur failed items `0` honi chahiye.
