
-- sale_transactions table
CREATE TABLE IF NOT EXISTS public.sale_transactions (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_id UUID REFERENCES public.contacts(id) ON DELETE SET NULL,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  invoice_no TEXT,
  subtotal NUMERIC DEFAULT 0,
  discount NUMERIC DEFAULT 0,
  total NUMERIC DEFAULT 0,
  paid_amount NUMERIC DEFAULT 0,
  payment_method TEXT DEFAULT 'cash',
  payment_status TEXT DEFAULT 'paid',
  customer_type TEXT,
  notes TEXT,
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.sale_transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage sale_transactions" ON public.sale_transactions FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Add product_name to sale_items if missing
ALTER TABLE public.sale_items ADD COLUMN IF NOT EXISTS product_name TEXT;

-- todos table
CREATE TABLE IF NOT EXISTS public.todos (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT false,
  priority TEXT,
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.todos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage todos" ON public.todos FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- returns table
CREATE TABLE IF NOT EXISTS public.returns (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  sale_id UUID REFERENCES public.sale_transactions(id) ON DELETE SET NULL,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  total_refund NUMERIC NOT NULL DEFAULT 0,
  refund_method TEXT,
  reason TEXT,
  notes TEXT,
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.returns ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage returns" ON public.returns FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- return_items table
CREATE TABLE IF NOT EXISTS public.return_items (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  return_id UUID NOT NULL REFERENCES public.returns(id) ON DELETE CASCADE,
  product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,
  product_name TEXT,
  quantity NUMERIC NOT NULL DEFAULT 1,
  unit_price NUMERIC NOT NULL DEFAULT 0,
  subtotal NUMERIC NOT NULL DEFAULT 0
);
ALTER TABLE public.return_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage return_items" ON public.return_items FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  title TEXT NOT NULL,
  message TEXT,
  type TEXT NOT NULL DEFAULT 'info',
  is_read BOOLEAN NOT NULL DEFAULT false,
  link TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own notifications" ON public.notifications FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- receivable_payments table
CREATE TABLE IF NOT EXISTS public.receivable_payments (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  sale_id UUID REFERENCES public.sale_transactions(id) ON DELETE SET NULL,
  contact_id UUID REFERENCES public.contacts(id) ON DELETE SET NULL,
  amount NUMERIC NOT NULL DEFAULT 0,
  payment_method TEXT DEFAULT 'cash',
  date DATE DEFAULT CURRENT_DATE,
  notes TEXT,
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.receivable_payments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage receivable_payments" ON public.receivable_payments FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Seed product categories
INSERT INTO public.product_categories (name) VALUES
  ('Water Filtration Plants'), ('RO Membranes'), ('Water Filters & Cartridges'),
  ('Water Bottles'), ('Pumps & Motors'), ('Pipes & Fittings'), ('UV Systems'),
  ('Water Coolers & Dispensers'), ('Accessories & Parts'), ('Chemicals & Media'),
  ('Installation Materials'), ('General')
ON CONFLICT DO NOTHING;

-- Seed expense categories
INSERT INTO public.expense_categories (name) VALUES
  ('Rent'), ('Utilities (Electricity/Gas/Water)'), ('Salaries & Wages'),
  ('Transport & Delivery'), ('Maintenance & Repairs'), ('Plant Equipment'),
  ('Raw Materials & Chemicals'), ('Packaging Materials'), ('Marketing & Advertising'),
  ('Office Supplies'), ('Phone & Internet'), ('Vehicle Fuel'), ('Insurance'), ('Miscellaneous')
ON CONFLICT DO NOTHING;
