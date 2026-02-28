$dir = "c:\Users\Steven\.gemini\antigravity\scratch\Restaurants in Anoka\Bakery Restaurant\bakerville-menu"
$files = Get-ChildItem -Path $dir -Filter "*.html" | Where-Object { $_.Name -ne "fix-nav.ps1" }

# Navigation mapping:
# "Bakerville" logo center -> full-menu.html (home)
# Menu -> full-menu.html
# Our Story / Story -> our-story.html
# Gallery -> full-menu.html (no separate gallery page)
# Catering / Catering & Events -> contact-catering.html
# Order Online -> shopping-cart.html
# Shopping bag icon -> shopping-cart.html
# Wholesale -> wholesale.html
# Careers -> careers.html
# Gift Cards -> gift-cards.html
# Contact / Contact Us -> contact-catering.html
# Locations -> contact-catering.html
# Back to Cart -> shopping-cart.html
# Continue Shopping -> full-menu.html
# Proceed to Checkout -> checkout.html
# View Our Menu -> full-menu.html

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # ============================================
    # NAVBAR LINKS (text-based matching)
    # ============================================
    
    # Menu nav link
    $content = $content -replace '(href=")#(">\s*Menu\s*</a>)', '${1}full-menu.html${2}'
    
    # Our Story nav link
    $content = $content -replace '(href=")#(">\s*Our Story\s*</a>)', '${1}our-story.html${2}'
    
    # Gallery nav link  
    $content = $content -replace '(href=")#(">\s*Gallery\s*</a>)', '${1}full-menu.html${2}'
    
    # Catering nav link
    $content = $content -replace '(href=")#(">\s*Catering\s*</a>)', '${1}contact-catering.html${2}'
    
    # Order Online nav link
    $content = $content -replace '(href=")#(">\s*Order Online\s*</a>)', '${1}shopping-cart.html${2}'
    
    # Reviews nav link (no reviews page, go home)
    $content = $content -replace '(href=")#(">\s*Reviews\s*</a>)', '${1}full-menu.html${2}'
    
    # Locations nav link
    $content = $content -replace '(href=")#(">\s*Locations\s*</a>)', '${1}contact-catering.html${2}'
    
    # Workshops nav link (no workshops page, go home)
    $content = $content -replace '(href=")#(">\s*Workshops\s*</a>)', '${1}full-menu.html${2}'
    
    # Wholesale nav link
    $content = $content -replace '(href=")#(">\s*Wholesale\s*</a>)', '${1}wholesale.html${2}'
    
    # Contact nav link
    $content = $content -replace '(href=")#(">\s*Contact\s*</a>)', '${1}contact-catering.html${2}'

    # ============================================
    # BAKERVILLE LOGO -> full-menu.html (HOME)
    # ============================================
    
    # Already <a> tags with href="#" or href="/"
    $content = $content -replace '(href=")#("[^>]*>\s*Bakerville\s*</a>)', '${1}full-menu.html${2}'
    $content = $content -replace '(href=")/("[^>]*>\s*Bakerville\s*</a>)', '${1}full-menu.html${2}'
    $content = $content -replace '(href=")#("[^>]*>\s*BAKERVILLE\s*</a>)', '${1}full-menu.html${2}'
    
    # full-menu.html: <h1 class="text-4xl tracking-tight font-display">Bakerville</h1>
    $content = $content -replace '<h1 class="text-4xl tracking-tight font-display">Bakerville</h1>', '<a href="full-menu.html" class="text-4xl tracking-tight font-display no-underline text-inherit hover:opacity-80 transition-opacity">Bakerville</a>'
    
    # wholesale.html: <h1 class="text-3xl font-light tracking-tight text-ink">Bakerville</h1>
    $content = $content -replace '<h1 class="text-3xl font-light tracking-tight text-ink">Bakerville</h1>', '<a href="full-menu.html" class="text-3xl font-light tracking-tight text-ink no-underline hover:opacity-80 transition-opacity">Bakerville</a>'
    
    # our-story.html: <h1 class="text-3xl font-serif tracking-tight">Bakerville</h1>
    $content = $content -replace '<h1 class="text-3xl font-serif tracking-tight">Bakerville</h1>', '<a href="full-menu.html" class="text-3xl font-serif tracking-tight no-underline text-inherit hover:opacity-80 transition-opacity">Bakerville</a>'
    
    # checkout.html: <h1 class="text-3xl font-display tracking-tight text-ink">Bakerville</h1>
    $content = $content -replace '<h1 class="text-3xl font-display tracking-tight text-ink">Bakerville</h1>', '<a href="full-menu.html" class="text-3xl font-display tracking-tight text-ink no-underline hover:opacity-80 transition-opacity">Bakerville</a>'

    # order-confirmation.html: <a ... href="/">Bakerville</a>
    $content = $content -replace '(href=")/("[^>]*>\s*Bakerville\s*</a>)', '${1}full-menu.html${2}'

    # ============================================
    # SHOPPING BAG ICON -> link to shopping-cart.html
    # ============================================
    
    # Wrap <button> with shopping_bag icon in an <a> tag
    # Pattern: <button ...><span class="material-symbols-outlined...">shopping_bag</span>...</button>
    $content = $content -replace '<button class="relative hover:text-olive transition-colors">\s*<span class="material-symbols-outlined font-light">shopping_bag</span>', '<a href="shopping-cart.html" class="relative hover:text-olive transition-colors"><span class="material-symbols-outlined font-light">shopping_bag</span>'
    $content = $content -replace '(shopping_bag</span>\s*<span class="absolute -top-1 -right-1[^"]*">[^<]*</span>\s*)</button>', '$1</a>'
    
    # Simpler shopping bag buttons
    $content = $content -replace '<button class="relative p-1">\s*<span class="material-symbols-outlined text-2xl">shopping_bag</span>', '<a href="shopping-cart.html" class="relative p-1"><span class="material-symbols-outlined text-2xl">shopping_bag</span>'
    
    # Other shopping bag button variants
    $content = $content -replace '<button class="([^"]*)">\s*<span class="material-symbols-outlined([^"]*)">\s*shopping_bag\s*</span>\s*</button>', '<a href="shopping-cart.html" class="$1"><span class="material-symbols-outlined$2">shopping_bag</span></a>'
    $content = $content -replace '<button class="ml-4 flex items-center">\s*<span class="material-symbols-outlined text-2xl font-light">shopping_bag</span>\s*</button>', '<a href="shopping-cart.html" class="ml-4 flex items-center"><span class="material-symbols-outlined text-2xl font-light">shopping_bag</span></a>'
    $content = $content -replace '<button class="relative">\s*<span class="material-symbols-outlined font-light text-bakerville-ink/80">shopping_bag</span>\s*</button>', '<a href="shopping-cart.html" class="relative"><span class="material-symbols-outlined font-light text-bakerville-ink/80">shopping_bag</span></a>'
    $content = $content -replace '<button class="flex items-center gap-2 hover:text-olive transition-colors">\s*<span class="material-symbols-outlined text-xl">shopping_bag</span>\s*</button>', '<a href="shopping-cart.html" class="flex items-center gap-2 hover:text-olive transition-colors"><span class="material-symbols-outlined text-xl">shopping_bag</span></a>'
    $content = $content -replace '<button class="flex items-center gap-2 hover:text-crust transition-colors">\s*<span class="material-symbols-outlined font-light">shopping_bag</span>\s*</button>', '<a href="shopping-cart.html" class="flex items-center gap-2 hover:text-crust transition-colors"><span class="material-symbols-outlined font-light">shopping_bag</span></a>'
    
    # ============================================
    # FOOTER LINKS
    # ============================================
    
    # Our Menu / Current Menu / Our Bakes
    $content = $content -replace '(href=")#(">\s*Our Menu\s*</a>)', '${1}full-menu.html${2}'
    $content = $content -replace '(href=")#(">\s*Current Menu\s*</a>)', '${1}full-menu.html${2}'
    $content = $content -replace '(href=")#(">\s*Our Bakes\s*</a>)', '${1}full-menu.html${2}'
    $content = $content -replace '(href=")#(">\s*Menu\s*</a>)', '${1}full-menu.html${2}'
    
    # Our Story
    $content = $content -replace '(href=")#(">\s*Our Story\s*</a>)', '${1}our-story.html${2}'
    $content = $content -replace '(href=")#(">\s*Story\s*</a>)', '${1}our-story.html${2}'
    $content = $content -replace '(href=")#(">\s*The Bakehouse\s*</a>)', '${1}our-story.html${2}'
    $content = $content -replace '(href=")#(">\s*The Bakery\s*</a>)', '${1}our-story.html${2}'
    
    # Gift Cards / Gift Vouchers
    $content = $content -replace '(href=")#(">\s*Gift Cards\s*</a>)', '${1}gift-cards.html${2}'
    $content = $content -replace '(href=")#(">\s*Gift Vouchers\s*</a>)', '${1}gift-cards.html${2}'
    
    # Careers / Join Our Team
    $content = $content -replace '(href=")#(">\s*Careers\s*</a>)', '${1}careers.html${2}'
    $content = $content -replace '(href=")#(">\s*Join Our Team\s*</a>)', '${1}careers.html${2}'
    
    # Wholesale
    $content = $content -replace '(href=")#(">\s*Wholesale\s*</a>)', '${1}wholesale.html${2}'
    $content = $content -replace '(href=")#(">\s*Wholesale Portal\s*</a>)', '${1}wholesale.html${2}'
    
    # Contact / Contact Us / Customer Care
    $content = $content -replace '(href=")#(">\s*Contact\s*</a>)', '${1}contact-catering.html${2}'
    $content = $content -replace '(href=")#(">\s*Contact Us\s*</a>)', '${1}contact-catering.html${2}'
    $content = $content -replace '(href=")#(">\s*Customer Care\s*</a>)', '${1}contact-catering.html${2}'
    
    # Locations
    $content = $content -replace '(href=")#(">\s*Locations\s*</a>)', '${1}contact-catering.html${2}'
    $content = $content -replace '(href=")#(">\s*Location Finder\s*</a>)', '${1}contact-catering.html${2}'
    
    # Newsletter
    $content = $content -replace '(href=")#(">\s*Newsletter\s*</a>)', '${1}full-menu.html${2}'
    
    # ============================================
    # CTA BUTTONS -> convert to <a> links
    # ============================================
    
    # "View Our Menu" button
    $content = $content -replace '<button class="(bg-olive text-white[^"]*)">\s*View Our Menu\s*</button>', '<a href="full-menu.html" class="$1 inline-block text-center no-underline">View Our Menu</a>'
    
    # "Order Online" button (in hero/CTA sections) 
    $content = $content -replace '<button class="(border border-olive[^"]*)">\s*Order Online\s*</button>', '<a href="shopping-cart.html" class="$1 inline-block text-center no-underline">Order Online</a>'
    
    # "Order Online" navbar button
    $content = $content -replace '<button class="(border border-ink[^"]*)">\s*Order Online\s*</button>', '<a href="shopping-cart.html" class="$1 inline-block text-center no-underline">Order Online</a>'

    # "Back to Cart" link in checkout
    $content = $content -replace '(href=")#("[^>]*>[\s\S]*?Back to Cart)', '${1}shopping-cart.html${2}'
    
    # "Proceed to Checkout" button in shopping cart
    $content = $content -replace '<button (class="w-full bg-olive text-white py-5 rounded-full uppercase[^"]*")>\s*Proceed to Checkout\s*([\s\S]*?)</button>', '<a href="checkout.html" $1>Proceed to Checkout $2</a>'

    # "Continue Shopping" button in order confirmation
    $content = $content -replace '<button (class="flex-1 bg-transparent border border-ink[^"]*")>\s*Continue Shopping\s*</button>', '<a href="full-menu.html" $1>Continue Shopping</a>'

    # "Full Catalog" link in wholesale
    $content = $content -replace '(href=")#("[^>]*>\s*Full Catalog)', '${1}full-menu.html${2}'

    Set-Content -Path $file.FullName -Value $content -NoNewline
    Write-Host "Updated: $($file.Name)"
}

Write-Host "`nAll navigation links updated! Bakerville logo -> full-menu.html (home)"
