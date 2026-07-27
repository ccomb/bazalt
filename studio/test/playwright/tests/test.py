from playwright.sync_api import Page, expect


def test_example(page: Page) -> None:
    page.goto("http://localhost:8080/")
    page.get_by_text("admin", exact=True).click()
    page.get_by_role("link", name="Identifier Types").first.click()
    page.get_by_role("button", name="Add...").click()
    page.get_by_text("Resource Types").nth(1).click()
    page.get_by_role("button", name="Next →").click()
    page.get_by_label("Give a name to this new Identifier TypeName").click()
    page.get_by_label("Give a name to this new Identifier TypeName").fill("Name")
    page.get_by_label("Give a name to this new Identifier TypeName").press("Enter")
    page.get_by_role("button", name="Next →").click()
    page.get_by_text("Free", exact=True).click()
    page.get_by_role("button", name="Validate and finish").click()
