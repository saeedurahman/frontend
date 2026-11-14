# Testing Guide

## Product

**Test data:** `Test Shop 3` (Grocery) naya aur khaali business hai. Is guide mein `Test Item` product aur ek test sale add hogi; yeh data business mein save rahega.

**Shuru karne se pehle:** `Test Shop 3` mein login hon, sahi branch selected ho, aur sync status `Online` ho.

1. **Product add karo:** Sidebar se `Products` → `Add Product` kholo.
2. **Fields detail mein fill karo:**
   - `Product Name *`: `Test Item`
   - `SKU`: `TEST-ITEM-001` (optional, lekin search mein asani ke liye useful)
   - `Category`: `None` rehne do; grocery business ke liye category zaroori nahi hoti.
   - `Brand`: `None` rehne do.
   - `Base Unit *`: `Piece` select karo. Agar list khali ho to `+ New Unit` dabao, `Unit name` = `Piece`, `Symbol` = `pc`, `Is base unit` tick karke `Save` dabao.
   - `Product Type *`: `Standard`
   - `Tracking Type *`: `None`
   - `Description`: `Test grocery item for online sale` (optional)
   - `Images`: skip karo (optional)
   - `Is Sellable`: ON rakho
   - `Is Purchasable`: ON rakho
   - `Min Stock Level` aur `Max Stock Level`: khali chhoro. Yeh alert thresholds hain, asal stock quantity nahi.
   - `Variations`: default variation khud banti hai; is test mein kuch add na karo.
   - `Barcodes`: khali rehne do, agar zaroorat nahi ho.
3. **Save karke product final karo:** `Save Product` dabao.

**Wajah:** Product Name aur Base Unit required hain. Yahan agar `Test Item` ko create karna hai to yeh fields zaroori hain; baaqi fields test ke liye optional hain. `Min Stock` aur `Max Stock` sirf stock alert ke liye hote hain, actual stock nahi.

## Online Sale

1. **Shift kholo:** Sidebar se `Cash Register` kholo. Agar active shift nahi hai to `Go to POS` dabao. POS par register setup na ho to `Create Main Counter Register` dabao; phir `Opening Float` mein `0` likh kar `Open Shift & Start Selling` dabao.
   **Wajah:** Sale cash register shift ke baghair complete nahi hoti.

2. **Product ready karo:** Agar product list khali ho to pehle `Test Item` banao (naam `Test Item`, price `100`, stock mein `10` ka adjustment ya purchase receive karo).
   **Wajah:** POS mein item ko add karne ke liye product, price aur stock sab hona chahiye.

3. **Cart mein add karo:** POS kholo. Search ya grid se `Test Item` daalo, quantity `1` rakho.
4. **Payment complete karo:** `PAY NOW` dabao, `Cash` payment method chuno, poori payable amount cash mein daal kar sale complete karo.
5. **Receipt print dialog cancel karo:** Receipt screen par `Print Receipt` dabao; agar print dialog aaye to `Cancel` kar do.
6. **Sync verify karo:** Sync status chip par click karke Sync page kholo (ya `/sync`), `Sync now` dabao, aur result dekho.

**Wajah:** Is se product, stock, price, payment aur online sale ka end-to-end flow test hota hai.

## Price Lists

1. **Sidebar se Price Lists kholo:** Sidebar par `Price Lists` par click karo. Agar list list mein koi default list available nahi hai to new list create karo.
2. **List select karo:** `Test Item` wali price list select karo ya default list open karo.
3. **Item ko search karo:** Search box mein `Test Item` likho.
4. **Price change karo:** `Test Item` ki price `100` se `120` ya koi nayi price par update karo.
5. **POS mein verify karo:** POS kholo, `Test Item` search karke cart mein add karo. Nayi price `120` show honi chahiye.

**Wajah:** Price Lists ke zariye product ki selling price dynamically update hoti hai. Yeh verify karne se pata chalta hai ke sale screen current price ke saath kaam kar raha hai.

## Export

1. **Reports / Sales list kholo:** Sidebar ya dashboard se `Sales` ya `Reports` ka section open karo.
2. **Sales data choose karo:** Date range set karo aur sale records ko filter karo.
3. **Excel export karo:** `Export`, `Download`, ya `Excel` button dabao. Agar app multiple formats de raha ho to `Excel` select karo.
4. **Save dialog handle karo:** File save dialog aaye; koi location choose karo aur `Save` dabao.
5. **File open karo:** Saved file ko open karo and confirm Excel workbook khul gaya.

**Wajah:** Export flow verify karne se data accuracy aur reporting correctness check hoti hai. Agar Excel open nahi hota to file format ya permissions issue ho sakti hai.

## Receipt

1. **Sale ko open karo:** Kisi test sale ke baad sale detail page par jao.
2. **Send on WhatsApp dabao:** `Send on WhatsApp` button par tap karo.
3. **App launch verify karo:** WhatsApp khule ya OS share sheet open ho. Agar WhatsApp installed nahi ho to share options show honay chahiye.
4. **Message preview dekho:** Receipt text ya receipt link preview mein dikhna chahiye.

**Wajah:** Yeh verify karta hai ke customer ko sale receipt easily share kiya ja sakta hai. Exact behavior device par depend karta hai, lekin app ko WhatsApp/share flow trigger karna chahiye.

## Printer

1. **Printer settings kholo:** Sidebar se `Settings` → `Receipt Printer` ya `Printer & Hardware Settings` open karo.
2. **Printer select karo:** Dropdown se connected printer choose karo. Agar physical printer connected na ho to `Save as PDF` wala option select karo.
3. **Test print karo:** `Test Print` ya `Print Test Page` button dabao.
4. **Result verify karo:**
   - Agar printer connected ho to print paper par sample receipt print hona chahiye.
   - Agar printer nahi ho to system PDF save dialog ya save as PDF option dikhna chahiye.
5. **Settings save karo:** `Save Settings` dabao.

**Wajah:** Receipt printing aur PDF fallback verify karne se user ko pata chalta hai ke print path kaam kar raha hai ya fail ho raha hai. Yeh testing important hai kyun ke POS sale ke baad receipt print hona chaiye.

## Final Quick Checklist

- Product `Test Item` bana hai
- Price `100` (ya test price) set hai
- Stock `10` adjust ho chuka hai
- Shift open hai
- POS sale successfully complete ho chuka hai
- Sync successful hai
- Price Lists update reflect ho rahi hai
- Export file save aur open ho rahi hai
- Receipt WhatsApp/share flow open ho rahi hai
- Printer test print ya PDF fallback kaam kar rahi hai

Ye complete checklist har testing cycle ke baad run karni chahiye taake business flow stable ho.
